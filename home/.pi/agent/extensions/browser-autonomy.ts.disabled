/**
 * browser-autonomy.ts
 *
 * Reliability layer for pi-web-ui's browser_page tool.
 *
 * Goals:
 * - normalize accidental Markdown URLs before browser_page executes
 * - remember page-picker targets returned by op:"pages"
 * - inject a cached target when the model omits one (best-effort)
 * - open an authorized-but-closed HTTP(S) page with xdg-open
 * - turn browser_page failures into terse, deterministic recovery instructions
 *
 * Install:
 *   cp browser-autonomy.ts ~/.pi/agent/extensions/browser-autonomy.ts
 *   # then /reload in Pi, or restart pi-web-ui
 */

import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

type AnyRecord = Record<string, unknown>;

const targetsByOrigin = new Map<string, string>();
let lastPagesText = "";

function textOfContent(content: unknown): string {
	if (!Array.isArray(content)) return "";
	return content
		.map((part) => {
			if (!part || typeof part !== "object") return "";
			const p = part as { type?: string; text?: string };
			return p.type === "text" && typeof p.text === "string" ? p.text : "";
		})
		.filter(Boolean)
		.join("\n");
}

function rawUrl(input: unknown): string | undefined {
	if (typeof input !== "string") return undefined;
	let s = input.trim();
	if (!s) return undefined;

	// [https://example.com](https://example.com) -> https://example.com
	const md = s.match(/^\[[^\]]*]\((https?:\/\/[^)]+)\)$/i);
	if (md) s = md[1];

	// <https://example.com> -> https://example.com
	if (/^<https?:\/\/[^>]+>$/i.test(s)) s = s.slice(1, -1);

	try {
		const u = new URL(s);
		if (u.protocol !== "http:" && u.protocol !== "https:") return undefined;
		return u.href;
	} catch {
		return undefined;
	}
}

function originOf(url: string): string | undefined {
	try {
		return new URL(url).origin;
	} catch {
		return undefined;
	}
}

function walkForPages(value: unknown): void {
	if (Array.isArray(value)) {
		for (const v of value) walkForPages(v);
		return;
	}
	if (!value || typeof value !== "object") return;

	const obj = value as AnyRecord;
	const candidateUrl =
		typeof obj.url === "string"
			? rawUrl(obj.url)
			: typeof obj.href === "string"
				? rawUrl(obj.href)
				: typeof obj.origin === "string"
					? rawUrl(obj.origin)
					: undefined;

	const target =
		typeof obj.target === "string"
			? obj.target
			: typeof obj.targetId === "string"
				? obj.targetId
				: typeof obj.id === "string"
					? obj.id
					: undefined;

	if (candidateUrl && target) {
		const origin = originOf(candidateUrl);
		if (origin) targetsByOrigin.set(origin, target);
	}

	for (const v of Object.values(obj)) walkForPages(v);
}

function learnTargets(text: string): void {
	lastPagesText = text;

	// First try structured JSON.
	try {
		walkForPages(JSON.parse(text));
	} catch {
		// Then accept common human-readable / JSON-ish forms.
		const jsonish =
			/"(?:url|href|origin)"\s*:\s*"(https?:\/\/[^"]+)"[\s\S]{0,300}?"(?:target|targetId|id)"\s*:\s*"([^"]+)"/gi;
		for (const m of text.matchAll(jsonish)) {
			const url = rawUrl(m[1]);
			if (!url) continue;
			const origin = originOf(url);
			if (origin) targetsByOrigin.set(origin, m[2]);
		}

		const reversed =
			/"(?:target|targetId|id)"\s*:\s*"([^"]+)"[\s\S]{0,300}?"(?:url|href|origin)"\s*:\s*"(https?:\/\/[^"]+)"/gi;
		for (const m of text.matchAll(reversed)) {
			const url = rawUrl(m[2]);
			if (!url) continue;
			const origin = originOf(url);
			if (origin) targetsByOrigin.set(origin, m[1]);
		}

		// target=<id> ... https://host   OR   https://host ... target=<id>
		const loose = /target(?:Id)?\s*[:=]\s*["']?([^\s"',}]+)["']?[\s\S]{0,180}?(https?:\/\/[^\s"',}<]+)/gi;
		for (const m of text.matchAll(loose)) {
			const url = rawUrl(m[2]);
			if (!url) continue;
			const origin = originOf(url);
			if (origin) targetsByOrigin.set(origin, m[1]);
		}
		const looseRev = /(https?:\/\/[^\s"',}<]+)[\s\S]{0,180}?target(?:Id)?\s*[:=]\s*["']?([^\s"',}]+)["']?/gi;
		for (const m of text.matchAll(looseRev)) {
			const url = rawUrl(m[1]);
			if (!url) continue;
			const origin = originOf(url);
			if (origin) targetsByOrigin.set(origin, m[2]);
		}
	}
}

async function openUrl(url: string): Promise<void> {
	if (process.platform !== "linux") {
		throw new Error("browser_open_url currently supports Linux/xdg-open only");
	}

	await new Promise<void>((resolve, reject) => {
		const child = spawn("xdg-open", [url], {
			detached: true,
			stdio: "ignore",
		});
		child.once("error", reject);
		child.once("spawn", () => {
			child.unref();
			resolve();
		});
	});
}

function extractHttpUrl(text: string): string | undefined {
	for (const m of text.matchAll(/https?:\/\/[^\s)\]}>，、]+/gi)) {
		const url = rawUrl(m[0]);
		if (url) return url;
	}
	return undefined;
}

function recoverySuffix(text: string): string | undefined {
	const lower = text.toLowerCase();

	if (
		lower.includes("multiple authorized") ||
		lower.includes("多个已授权页面") ||
		(lower.includes("target") && lower.includes('op:"pages"'))
	) {
		return [
			"BROWSER_AUTONOMY_RECOVERY:",
			'Call browser_page with {"op":"pages"} now.',
			"Then use the exact target returned for the requested page.",
			"Do not call goto again before pages.",
		].join("\n");
	}

	if (
		(lower.includes("not open") || lower.includes("未打开")) &&
		(lower.includes("page") || lower.includes("页面"))
	) {
		return [
			"BROWSER_AUTONOMY_RECOVERY:",
			"The requested page was not open.",
			"It has been opened automatically when a URL could be recovered.",
			'Now call browser_page with {"op":"pages"}, then use the exact returned target.',
		].join("\n");
	}

	return undefined;
}

export default function browserAutonomy(pi: ExtensionAPI) {
	pi.registerTool({
		name: "browser_open_url",
		label: "Open browser URL",
		description:
			"Open an HTTP(S) URL in the user's browser when browser_page reports that the page is not open. " +
			"Accepts raw or accidentally Markdown-formatted URLs. After this tool succeeds, call browser_page with op:'pages' and use the exact returned target.",
		promptSnippet: "open a browser page before controlling it",
		promptGuidelines: [
			"For browser tasks, prefer browser_page. Begin with browser_page op:'pages' when targets are unknown.",
			"Never place Markdown link syntax inside tool arguments; use raw absolute URLs.",
			"If browser_page says a page is not open, call browser_open_url, then browser_page op:'pages', then continue with the exact returned target.",
			"If browser_page says multiple pages are authorized or target is required, call browser_page op:'pages' immediately.",
		],
		parameters: Type.Object({
			url: Type.String({
				description: "HTTP(S) URL to open, preferably a raw absolute URL such as https://reddit.com",
			}),
		}),
		async execute(_toolCallId, params) {
			const url = rawUrl((params as { url?: unknown }).url);
			if (!url) {
				throw new Error("browser_open_url requires a valid http:// or https:// URL");
			}

			await openUrl(url);
			await new Promise((resolve) => setTimeout(resolve, 800));

			const known = targetsByOrigin.get(originOf(url) ?? "");
			return {
				content: [
					{
						type: "text",
						text: known
							? `Opened ${url}. A cached page-picker target for this origin is ${JSON.stringify(known)}. Call browser_page op:"pages" to refresh/confirm it before interaction.`
							: `Opened ${url}. NEXT: call browser_page with {"op":"pages"}, select the exact target for ${originOf(url)}, then continue.`,
					},
				],
				details: { url, knownTarget: known ?? null },
			};
		},
	});

	// Guard/repair browser_page calls. Pi's hook gets the live input object in current
	// releases, so normalizing fields in place is useful. The explicit block paths
	// remain deterministic even if a future runtime stops honoring mutation.
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "browser_page") return undefined;

		const input = event.input as AnyRecord;
		const op = typeof input.op === "string" ? input.op : "";

		if (typeof input.url === "string") {
			const normalized = rawUrl(input.url);
			if (!normalized) {
				return {
					block: true,
					reason:
						'Invalid browser URL. Use a raw absolute http(s) URL, e.g. {"op":"goto","target":"<target>","url":"https://reddit.com"}.',
				};
			}
			input.url = normalized;
		}

		if (op === "pages") return undefined;

		if (typeof input.target !== "string" || !input.target.trim()) {
			const url = typeof input.url === "string" ? input.url : undefined;
			const origin = url ? originOf(url) : undefined;
			const cached = origin ? targetsByOrigin.get(origin) : undefined;

			if (cached) {
				// Best-effort auto-repair for current Pi versions.
				input.target = cached;
				return undefined;
			}

			return {
				block: true,
				reason:
					'BROWSER_AUTONOMY: target is unknown. Call browser_page with {"op":"pages"} first; then retry using the exact returned target. Never use a URL as target.',
			};
		}

		return undefined;
	});

	pi.on("tool_result", async (event) => {
		if (event.toolName !== "browser_page") return undefined;

		const input = event.input as AnyRecord;
		const op = typeof input.op === "string" ? input.op : "";
		const text = textOfContent(event.content);

		if (op === "pages" && text) {
			learnTargets(text);
			return undefined;
		}

		if (!event.isError || !text) return undefined;

		const suffix = recoverySuffix(text);
		if (!suffix) return undefined;

		// If page-picker says the page is closed, open the URL automatically.
		if (text.toLowerCase().includes("not open") || text.includes("未打开")) {
			const url = extractHttpUrl(text);
			if (url) {
				try {
					await openUrl(url);
					await new Promise((resolve) => setTimeout(resolve, 800));
				} catch {
					// Keep the original browser_page error; the recovery text still
					// tells the agent what to do next.
				}
			}
		}

		return {
			content: [
				...(event.content as Array<{ type: "text"; text: string }>),
				{ type: "text", text: `\n${suffix}` },
			],
			details: event.details,
			isError: event.isError,
		};
	});

	pi.registerCommand("browser-autonomy-status", {
		description: "Show browser-autonomy target cache",
		handler: async (_args, ctx) => {
			const rows = [...targetsByOrigin.entries()];
			const msg =
				rows.length > 0
					? rows.map(([origin, target]) => `${origin} -> ${target}`).join("\n")
					: `No cached targets yet.${lastPagesText ? "\nA pages response was seen but no target mapping was parsed." : ""}`;
			ctx.ui.notify(msg, "info");
		},
	});
}

