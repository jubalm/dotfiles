#!/usr/bin/env node
'use strict';

// Retrieve the Brave Search API key from the macOS Keychain.
//
// Keychain entry: generic password with service `brave-search`,
// account defaulting to the current user ($USER). Both are overridable
// via env vars in case the key was stored differently.
//
// Usage:
//   node scripts/get-key.js            # print key to stdout
//   $(node scripts/get-key.js)         # inline via command substitution
//
// The script resolves its own directory, so it works from any CWD and any
// install location. Writes the secret ONLY to stdout; never to a variable,
// file, or log.

const { execSync } = require('child_process');
const { EOL } = require('os');

const SERVICE = process.env.BRAVE_KEYCHAIN_SERVICE || 'brave-search';
const ACCOUNT = process.env.BRAVE_KEYCHAIN_ACCOUNT || process.env.USER;

function run(cmd) {
  return execSync(cmd, { encoding: 'utf8', stdio: ['pipe', 'pipe', 'ignore'] }).trim();
}

// True when a matching keychain item exists.
function hasKey() {
  try {
    execSync(
      `security find-generic-password -a ${shellQ(ACCOUNT)} -s ${shellQ(SERVICE)}`,
      { encoding: 'utf8', stdio: ['pipe', 'pipe', 'ignore'] }
    );
    return true;
  } catch {
    return false;
  }
}

function getKey() {
  return run(`security find-generic-password -a ${shellQ(ACCOUNT)} -s ${shellQ(SERVICE)} -w`);
}

// Minimal POSIX shell quoting for an argv embedded into a `security` call.
function shellQ(s) {
  return `'${String(s).replace(/'/g, `'\\''`)}'`;
}

if (!process.env.USER) {
  process.stderr.write('get-key.js: $USER is unset; set BRAVE_KEYCHAIN_ACCOUNT explicitly.' + EOL);
  process.exit(2);
}

if (!hasKey()) {
  process.stderr.write(
    [
      `get-key.js: no keychain item found (service=${SERVICE}, account=${ACCOUNT}).`,
      '',
      'Store your Brave Search API key first:',
      '',
      '  # get a key at https://api.search.brave.com',
      '  security add-generic-password -a "$USER" -s brave-search -w "YOUR_API_KEY"',
      '',
      'Or, if stored under a different account/service, pass them via env:',
      '',
      `  BRAVE_KEYCHAIN_ACCOUNT=<acct> BRAVE_KEYCHAIN_SERVICE=<svc> node "${__filename}"`,
      '',
    ].join(EOL)
  );
  process.exit(1);
}

process.stdout.write(getKey());
