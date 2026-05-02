/**
 * Compaction Model Extension for Pi
 *
 * Routes compaction (context summarization) to a user-configured model
 * instead of the current session model. Configure via settings.json:
 *
 *   {
 *     "compaction": {
 *       "model": "provider/model-id"
 *     }
 *   }
 *
 * If the model is unavailable or auth fails, shows a warning and falls
 * back to default compaction with the session model.
 */

import { complete } from "@mariozechner/pi-ai";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { convertToLlm, serializeConversation } from "@mariozechner/pi-coding-agent";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { homedir } from "node:os";

interface CompactionModelSettings {
	compaction?: {
		model?: string;
	};
}

function readCompactionModel(cwd: string): string | undefined {
	const files = [
		join(cwd, ".pi", "settings.json"),
		join(homedir(), ".pi", "agent", "settings.json"),
	];

	for (const file of files) {
		if (!existsSync(file)) continue;
		try {
			const raw = readFileSync(file, "utf8");
			const settings: CompactionModelSettings = JSON.parse(raw);
			if (settings.compaction?.model) return settings.compaction.model;
		} catch {
			// Malformed JSON or unreadable file — skip
		}
	}

	return undefined;
}

export default function (pi: ExtensionAPI) {
	pi.on("session_before_compact", async (event, ctx) => {
		const cwd = ctx.cwd;
		const compactionModel = readCompactionModel(cwd);

		if (!compactionModel) return;

		const slash = compactionModel.indexOf("/");
		if (slash === -1) {
			if (ctx.hasUI) {
				ctx.ui.notify(
					`Invalid compaction model format "${compactionModel}", expected "provider/model-id"`,
					"warning",
				);
			}
			return;
		}

		const provider = compactionModel.slice(0, slash);
		const modelId = compactionModel.slice(slash + 1);

		const model = ctx.modelRegistry.find(provider, modelId);
		if (!model) {
			if (ctx.hasUI) {
				ctx.ui.notify(
					`Compaction model ${compactionModel} not found, falling back to session model`,
					"warning",
				);
			}
			return;
		}

		const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
		if (!auth.ok) {
			if (ctx.hasUI) {
				ctx.ui.notify(`Compaction auth failed: ${auth.error}, falling back to session model`, "warning");
			}
			return;
		}
		if (!auth.apiKey) {
			if (ctx.hasUI) {
				ctx.ui.notify(
					`No API key for ${compactionModel}, falling back to session model`,
					"warning",
				);
			}
			return;
		}

		const { preparation, signal } = event;
		const {
			messagesToSummarize,
			turnPrefixMessages,
			tokensBefore,
			firstKeptEntryId,
			previousSummary,
		} = preparation;

		const allMessages = [...messagesToSummarize, ...turnPrefixMessages];

		if (ctx.hasUI) {
			ctx.ui.notify(
				`Compacting with ${compactionModel} (${tokensBefore.toLocaleString()} tokens)...`,
				"info",
			);
		}

		const conversationText = serializeConversation(convertToLlm(allMessages));
		const previousContext = previousSummary
			? `\n\nPrevious session summary for context:\n${previousSummary}`
			: "";

		const summaryMessages = [
			{
				role: "user" as const,
				content: [
					{
						type: "text" as const,
						text: `You are a conversation summarizer. Create a comprehensive summary of this conversation that captures:${previousContext}

1. The main goals and objectives discussed
2. Key decisions made and their rationale
3. Important code changes, file modifications, or technical details
4. Current state of any ongoing work
5. Any blockers, issues, or open questions
6. Next steps that were planned or suggested

Be thorough but concise. The summary will replace the ENTIRE conversation history, so include all information needed to continue the work effectively.

Format the summary as structured markdown with clear sections.

<conversation>
${conversationText}
</conversation>`,
					},
				],
				timestamp: Date.now(),
			},
		];

		try {
			const response = await complete(
				model,
				{ messages: summaryMessages },
				{
					apiKey: auth.apiKey,
					headers: auth.headers,
					maxTokens: 8192,
					signal,
				},
			);

			const summary = response.content
				.filter((c): c is { type: "text"; text: string } => c.type === "text")
				.map((c) => c.text)
				.join("\n");

			if (!summary.trim()) {
				if (!signal.aborted && ctx.hasUI) {
					ctx.ui.notify("Compaction summary was empty, falling back to session model", "warning");
				}
				return;
			}

			return {
				compaction: {
					summary,
					firstKeptEntryId,
					tokensBefore,
				},
			};
		} catch (error) {
			const message = error instanceof Error ? error.message : String(error);
			if (ctx.hasUI) {
				ctx.ui.notify(`Compaction failed: ${message}, falling back to session model`, "warning");
			}
			return;
		}
	});
}
