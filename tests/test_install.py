"""Installer regression tests; all filesystem changes stay in temporary homes."""

import contextlib
import os
from pathlib import Path
import runpy
import tempfile
import unittest
from unittest import mock


INSTALLER_PATH = Path(__file__).resolve().parents[1] / "install.py"
DotfilesInstaller = runpy.run_path(str(INSTALLER_PATH))["DotfilesInstaller"]


class InstallerTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name).resolve()
        self.installer = self.make_installer(self.root)
        self.home = self.installer.home_dir
        self.repo = self.installer.dotfiles_dir

    def make_installer(self, root):
        installer = DotfilesInstaller()
        installer.home_dir = root / "home"
        installer.dotfiles_dir = root / "repo"
        installer.backup_dir = root / "backups"
        installer.home_dir.mkdir(parents=True)
        (installer.dotfiles_dir / "home").mkdir(parents=True)
        installer.logger = mock.Mock()
        installer._command_exists = mock.Mock(return_value=True)
        installer._run_command = mock.Mock(
            side_effect=AssertionError("Tests must not run external commands")
        )
        return installer

    def source(self, relative, contents="fixture\n"):
        path = self.repo / "home" / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(contents)
        return path

    def link(self, relative, source):
        path = self.home / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.symlink_to(source)
        return path

    def test_cleanup_removes_only_exact_missing_repo_targets(self):
        source_dir = self.repo / "home/.claude"
        current = self.source(".claude/current.json")
        removed = [
            self.link(f".claude/{name}.json", source_dir / f"{name}.json")
            for name in ("removed", "retired", "obsolete")
        ]
        relative = self.link(
            ".claude/relative.json",
            os.path.relpath(source_dir / "relative.json", self.home / ".claude"),
        )
        preserved = {
            "current.json": current,
            "unmanaged.json": self.home / "missing.json",
            "elsewhere.json": self.repo / "other/elsewhere.json",
            "renamed.json": source_dir / "different-name.json",
            "prefix.json": self.root / "repo-other/home/.claude/prefix.json",
        }
        for name, target in preserved.items():
            self.link(f".claude/{name}", target)
        regular = self.home / ".claude/local.json"
        regular.write_text("local data\n")
        directory = self.home / ".claude/local-directory"
        directory.mkdir()
        (directory / "data").write_text("local data\n")

        for pass_number in range(2):
            with self.subTest(pass_number=pass_number):
                self.installer._remove_stale_symlinks(self.home / ".claude", source_dir)

                for target in [*removed, relative]:
                    self.assertFalse(os.path.lexists(target))
        for name, target in preserved.items():
            with self.subTest(name=name):
                path = self.home / ".claude" / name
                self.assertTrue(path.is_symlink())
                self.assertEqual(path.readlink(), target)
        self.assertEqual(regular.read_text(), "local data\n")
        self.assertEqual((directory / "data").read_text(), "local data\n")

    def test_cleanup_preserves_links_when_directory_scanning_fails(self):
        source_dir = self.repo / "home/.claude"
        target_dir = self.home / ".claude"
        removed = self.link(".claude/removed.json", source_dir / "removed.json")
        before = removed.lstat()

        def incomplete_scan():
            yield removed
            raise PermissionError("fixture: directory scan interrupted")

        for partial_scan in (False, True):
            with self.subTest(partial_scan=partial_scan):
                self.installer.logger.warning.reset_mock()
                if partial_scan:
                    scan = mock.patch.object(Path, "iterdir", return_value=incomplete_scan())
                else:
                    scan = mock.patch.object(
                        Path, "iterdir", side_effect=PermissionError("fixture: directory unreadable")
                    )

                with scan:
                    self.installer._remove_stale_symlinks(target_dir, source_dir)

                self.assertTrue(removed.is_symlink())
                self.assertEqual(removed.lstat().st_ino, before.st_ino)
                self.installer.logger.warning.assert_called_once()
                self.installer.logger.info.assert_not_called()

    def test_cleanup_does_not_follow_a_symlinked_destination_directory(self):
        actual = self.home / "custom-claude"
        actual.mkdir()
        removed = actual / "removed.json"
        source_dir = self.repo / "home/.claude"
        removed.symlink_to(source_dir / removed.name)
        alias = self.link(".claude", actual)

        self.installer._remove_stale_symlinks(alias, source_dir)

        self.assertTrue(removed.is_symlink())

    def test_cleanup_rejects_a_source_directory_outside_the_repo(self):
        actual = self.home / "custom-source"
        actual.mkdir()
        source_dir = self.repo / "home/.claude"
        source_dir.symlink_to(actual)
        removed = self.link(".claude/removed.json", source_dir / "removed.json")

        self.installer._remove_stale_symlinks(self.home / ".claude", source_dir)

        self.assertTrue(removed.is_symlink())

    def test_cleanup_preserves_symlink_loops(self):
        loop = self.link(".claude/loop.json", "loop.json")

        self.installer._remove_stale_symlinks(
            self.home / ".claude", self.repo / "home/.claude"
        )

        self.assertTrue(loop.is_symlink())

    def test_cleanup_preserves_links_when_source_inspection_is_denied(self):
        source_dir = self.repo / "home/.claude"
        source = source_dir / "removed.json"
        target = self.link(".claude/removed.json", source)
        original_lstat = Path.lstat

        def guarded_lstat(path, *args, **kwargs):
            if path == source:
                raise PermissionError("fixture: source inspection denied")
            return original_lstat(path, *args, **kwargs)

        with mock.patch.object(Path, "lstat", autospec=True, side_effect=guarded_lstat):
            self.installer._remove_stale_symlinks(self.home / ".claude", source_dir)

        self.assertTrue(target.is_symlink())
        self.installer.logger.warning.assert_called()

    def test_cleanup_preserves_links_when_the_source_is_itself_a_symlink(self):
        source_dir = self.repo / "home/.claude"
        source_dir.mkdir()
        source = source_dir / "loop.json"
        source.symlink_to(source.name)
        target = self.link(".claude/loop.json", source)

        self.installer._remove_stale_symlinks(self.home / ".claude", source_dir)

        self.assertTrue(target.is_symlink())
        self.assertTrue(source.is_symlink())

    def test_pi_installs_current_skills_and_prunes_only_owned_stale_links(self):
        current = self.source(".agents/skills/current/SKILL.md").parent
        shared = self.link(".agents/skills", current.parent)
        removed = self.link(".pi/agent/skills/removed", shared / "removed")
        unmanaged = self.link(".pi/agent/skills/unmanaged", self.home / "missing-skill")
        local = self.home / ".pi/agent/skills/local/SKILL.md"
        local.parent.mkdir()
        local.write_text("local skill\n")

        for _ in range(2):
            self.installer._install_pi()

        self.assertFalse(os.path.lexists(removed))
        self.assertEqual((self.home / ".pi/agent/skills/current").resolve(), current)
        self.assertTrue(unmanaged.is_symlink())
        self.assertEqual(local.read_text(), "local skill\n")
        self.installer._run_command.assert_not_called()

    def test_pi_prunes_retired_extensions_even_when_source_directory_is_gone(self):
        source_dir = self.repo / "home/.pi/agent/extensions"
        unmanaged = self.link(".pi/agent/extensions/unmanaged.ts", self.home / "missing.ts")
        local = self.home / ".pi/agent/extensions/local.ts"
        local.write_text("// local extension\n")
        for has_sources in (False, True):
            with self.subTest(has_sources=has_sources):
                if has_sources:
                    current = self.source(".pi/agent/extensions/current.ts")
                removed = self.link(".pi/agent/extensions/removed.ts", source_dir / "removed.ts")

                self.installer._install_pi()

                self.assertFalse(os.path.lexists(removed))
                self.assertTrue(unmanaged.is_symlink())
                self.assertEqual(local.read_text(), "// local extension\n")
                if has_sources:
                    self.assertEqual((local.parent / "current.ts").resolve(), current)

    def test_pi_leaves_skills_alone_when_agent_skills_are_skipped(self):
        current = self.source(".agents/skills/current/SKILL.md").parent
        shared = self.link(".agents/skills", current.parent)
        removed = self.link(".pi/agent/skills/removed", shared / "removed")
        self.installer.skip_sections = ["agent-skills"]

        self.installer._install_pi()

        self.assertTrue(removed.is_symlink())
        self.assertFalse(os.path.lexists(removed.parent / "current"))
        self.assertTrue(shared.is_symlink())

    def test_claude_prunes_retired_links_even_when_source_directory_is_gone(self):
        self.source(".agents/AGENTS.md")
        unmanaged = self.link(".claude/unmanaged.json", self.home / "missing.json")
        local = self.home / ".claude/local-data"
        local.write_text("local data\n")
        for has_sources in (False, True):
            with self.subTest(has_sources=has_sources):
                if has_sources:
                    current = self.source(".claude/current.json")
                removed = self.link(
                    ".claude/removed.json", self.repo / "home/.claude/removed.json"
                )

                self.installer._install_claude()

                self.assertFalse(os.path.lexists(removed))
                self.assertTrue(unmanaged.is_symlink())
                self.assertEqual(local.read_text(), "local data\n")
                self.assertTrue((local.parent / "CLAUDE.md").exists())
                if has_sources:
                    self.assertEqual((local.parent / "current.json").resolve(), current)
        self.installer._run_command.assert_not_called()

    def test_claude_leaves_shared_skill_link_alone_when_skills_are_skipped(self):
        self.source(".claude/current.json")
        skills = self.link(".claude/skills", self.home / ".agents/skills")
        self.installer.skip_sections = ["agent-skills"]

        self.installer._install_claude()

        self.assertTrue(skills.is_symlink())
        self.assertEqual(skills.readlink(), self.home / ".agents/skills")

    def test_tmux_migration_removes_only_the_exact_retired_repo_link(self):
        for kind in ("retired", "valid", "source-symlink", "unmanaged", "prefix", "file", "directory", "loop", "absent"):
            with self.subTest(kind=kind):
                installer = self.make_installer(self.root / kind)
                target = installer.home_dir / ".config/tmux"
                source = installer.dotfiles_dir / "home/.config/tmux"
                target.parent.mkdir()
                if kind in {"retired", "valid", "source-symlink"}:
                    target.symlink_to(source)
                    if kind == "valid":
                        source.mkdir(parents=True)
                    elif kind == "source-symlink":
                        source.parent.mkdir(parents=True)
                        source.symlink_to(installer.home_dir / "missing-tmux")
                elif kind == "unmanaged":
                    target.symlink_to(installer.home_dir / "unmanaged-tmux")
                elif kind == "prefix":
                    target.symlink_to(installer.dotfiles_dir.with_name("repo-other") / "home/.config/tmux")
                elif kind == "file":
                    target.write_text("local config\n")
                elif kind == "directory":
                    target.mkdir()
                    (target / "tmux.conf").write_text("local config\n")
                elif kind == "loop":
                    target.symlink_to("tmux")

                installer._remove_legacy_tmux()
                installer._remove_legacy_tmux()

                self.assertEqual(os.path.lexists(target), kind not in {"retired", "absent"})
                if kind == "file":
                    self.assertEqual(target.read_text(), "local config\n")
                elif kind == "directory":
                    self.assertEqual((target / "tmux.conf").read_text(), "local config\n")

    def test_tmux_migration_accepts_a_symlinked_repository_path(self):
        alias = self.root / "repo-alias"
        alias.symlink_to(self.repo)
        target = self.link(".config/tmux", alias / "home/.config/tmux")
        self.installer.dotfiles_dir = alias

        self.installer._remove_legacy_tmux()

        self.assertFalse(os.path.lexists(target))

    def test_each_skip_flag_preserves_existing_section_data(self):
        sections = {
            "dependencies": ["_install_homebrew", "_install_dependencies"],
            "handy": ["_install_handy"],
            "zsh": ["_install_zsh", "_remove_legacy_cld"],
            "git": ["_install_git"],
            "nodejs": ["_install_nodejs"],
            "claude": ["_install_claude"],
            "nvim": ["_install_neovim"],
            "ghostty": ["_install_ghostty"],
            "herdr": ["_install_herdr"],
            "lazygit": ["_install_lazygit"],
            "agent-skills": ["_install_agent_skills"],
            "pi": ["_install_pi"],
        }
        files = [
            ".zshrc", ".gitignore_global", ".config/zsh/local.zsh",
            ".claude/local-data", ".config/nvim/local.lua", ".config/lazygit/local.yml",
            ".config/ghostty/config", ".config/ghostty/auto/theme.ghostty",
            ".config/herdr/config.toml", ".config/handy/settings.shared.json",
            ".pi/agent/extensions/local.ts", ".pi/agent/skills/local/SKILL.md",
        ]
        for relative in files:
            path = self.home / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("local data\n")
        source = self.source(".agents/skills/current/SKILL.md").parent.parent
        links = [
            self.link(".agents/skills", source),
            self.link(".claude/skills", self.home / ".agents/skills"),
            self.link(".pi/agent/skills/removed", self.home / ".agents/skills/removed"),
            self.link(".local/bin/cld", self.repo / "bin/cld"),
        ]
        targets = {link: link.readlink() for link in links}
        with contextlib.ExitStack() as stack:
            methods = {
                name: stack.enter_context(mock.patch.object(self.installer, name))
                for names in sections.values() for name in names
            }
            stack.enter_context(mock.patch.object(self.installer, "_install_agents_md"))
            stack.enter_context(mock.patch.object(self.installer, "_remove_legacy_tmux"))
            for section in sections:
                with self.subTest(section=section):
                    for method in methods.values():
                        method.reset_mock()
                    self.installer.skip_sections = [section]

                    self.installer.run()

                    for candidate, names in sections.items():
                        for name in names:
                            self.assertEqual(methods[name].call_count, int(candidate != section))
                    for relative in files:
                        self.assertEqual((self.home / relative).read_text(), "local data\n")
                    for link, target in targets.items():
                        self.assertTrue(link.is_symlink())
                        self.assertEqual(link.readlink(), target)

    def test_no_zsh_run_preserves_the_legacy_cld_link(self):
        self.source(".agents/AGENTS.md")
        legacy_source = self.repo / "bin/cld"
        cld = self.link(".local/bin/cld", legacy_source)
        before = cld.lstat()
        self.installer.skip_sections = [
            "dependencies", "handy", "zsh", "git", "nodejs", "claude", "nvim",
            "ghostty", "herdr", "lazygit", "agent-skills", "pi",
        ]

        self.installer.run()

        self.assertTrue(cld.is_symlink())
        self.assertEqual(cld.readlink(), legacy_source)
        self.assertEqual(cld.lstat().st_ino, before.st_ino)
        self.assertEqual(cld.lstat().st_mtime_ns, before.st_mtime_ns)
        self.installer._run_command.assert_not_called()

    def test_shared_skills_are_installed_before_consumers_on_a_fresh_install(self):
        self.source(".agents/AGENTS.md")
        current = self.source(".agents/skills/current/SKILL.md").parent
        self.source(".claude/current.json")
        self.installer.skip_sections = [
            "dependencies", "handy", "zsh", "git", "nodejs", "nvim",
            "ghostty", "herdr", "lazygit",
        ]

        for _ in range(2):
            self.installer.run()

            self.assertEqual((self.home / ".agents/skills").resolve(), current.parent)
            self.assertEqual((self.home / ".claude/skills").resolve(), current.parent)
            self.assertEqual((self.home / ".pi/agent/skills/current").resolve(), current)
        self.installer._run_command.assert_not_called()
        self.assertFalse(list(self.installer.backup_dir.glob("*")))


if __name__ == "__main__":
    unittest.main()
