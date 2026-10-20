import { Type } from "typebox";

const BASE_TOOLS = ["read", "bash", "edit", "write", "mcp", "mcpScript", "discover_tools"];

const CONCEPT_GROUPS = [
  ["web", "browser", "browse", "url", "http", "https", "page", "site", "navigate", "navigation", "chrome", "chromium", "playwright", "devtools"],
  ["search", "find", "lookup", "locate", "discover", "query", "grep", "match"],
  ["file", "filesystem", "path", "directory", "folder", "read", "write", "edit", "document", "text"],
  ["shell", "bash", "terminal", "command", "exec", "process", "system"],
  ["git", "github", "repository", "repo", "commit", "branch", "pull", "pr", "issue"],
  ["agent", "subagent", "delegate", "worker", "parallel", "handoff"],
  ["task", "todo", "job", "schedule", "scheduled", "reminder"],
  ["network", "router", "lan", "wifi", "wireless", "dhcp", "dns", "nas", "openwrt"],
  ["container", "docker", "compose", "podman"],
  ["image", "vision", "screenshot", "photo", "picture", "media"],
  ["email", "mail", "gmail", "message", "inbox"],
  ["calendar", "event", "meeting", "appointment", "schedule"],
  ["mcp", "server", "remote", "external", "tool", "capability"]
];

const STOP = new Set(["a","an","and","as","at","be","by","for","from","in","into","is","it","of","on","or","the","to","with"]);

function words(s) {
  return String(s || "")
    .toLowerCase()
    .replace(/[_./:-]+/g, " ")
    .replace(/[^a-z0-9 ]+/g, " ")
    .split(/\s+/)
    .filter((x) => x && !STOP.has(x));
}

function expanded(s) {
  const out = new Set(words(s));
  for (const group of CONCEPT_GROUPS) {
    if (group.some((w) => out.has(w))) for (const w of group) out.add(w);
  }
  return out;
}

function trigrams(s) {
  const x = `  ${String(s || "").toLowerCase().replace(/[^a-z0-9]+/g, " ").trim()}  `;
  const out = new Set();
  for (let i = 0; i + 3 <= x.length; i++) out.add(x.slice(i, i + 3));
  return out;
}

function jaccard(a, b) {
  if (!a.size || !b.size) return 0;
  let both = 0;
  for (const x of a) if (b.has(x)) both++;
  return both / (a.size + b.size - both);
}

function scoreTool(query, tool) {
  const qRaw = String(query || "").toLowerCase().trim();
  const name = String(tool.name || "").toLowerCase();
  const desc = String(tool.description || "");
  const hay = `${name.replace(/[_-]+/g, " ")} ${desc}`.toLowerCase();
  const q = expanded(qRaw);
  const h = expanded(hay);
  let overlap = 0;
  for (const x of q) if (h.has(x)) overlap++;
  let score = q.size ? (overlap / Math.sqrt(q.size * Math.max(1, h.size))) * 12 : 0;
  for (const token of words(qRaw)) {
    if (name === token) score += 12;
    else if (name.includes(token)) score += 5;
    if (hay.includes(token)) score += 2;
  }
  if (qRaw && hay.includes(qRaw)) score += 10;
  score += jaccard(trigrams(qRaw), trigrams(`${name} ${desc.slice(0, 240)}`)) * 8;
  return score;
}

export default function semanticToolGate(pi) {
  const discovered = new Set();

  function availableNames() {
    return new Set(pi.getAllTools().map((t) => t.name));
  }

  function wanted() {
    const available = availableNames();
    const out = [];
    for (const name of BASE_TOOLS) if (available.has(name)) out.push(name);
    for (const name of discovered) if (available.has(name) && !out.includes(name)) out.push(name);
    return out;
  }

  function applyGate() {
    const want = wanted();
    const cur = pi.getActiveTools();
    if (cur.length === want.length && cur.every((x, i) => x === want[i])) return;
    pi.setActiveTools(want);
  }

  pi.registerTool({
    name: "discover_tools",
    label: "Discover Tools",
    description: "Find and activate hidden Pi tools by capability. Use only when the currently active tools cannot perform the task.",
    promptSnippet: "Discover additional tools by capability only when the active tool set is insufficient",
    parameters: Type.Object({
      query: Type.String({ description: "Short capability phrase, e.g. browser navigation, delegate subagent, task tracking" }),
      limit: Type.Optional(Type.Integer({ minimum: 1, maximum: 5, default: 3 }))
    }),
    async execute(_toolCallId, params) {
      const limit = Math.max(1, Math.min(Number(params.limit || 3), 5));
      const active = new Set(pi.getActiveTools());
      const candidates = pi.getAllTools()
        .filter((t) => !active.has(t.name) && t.name !== "discover_tools")
        .map((t) => ({ tool: t, score: scoreTool(params.query, t) }))
        .filter((x) => x.score >= 1.2)
        .sort((a, b) => b.score - a.score || a.tool.name.localeCompare(b.tool.name))
        .slice(0, limit);

      if (!candidates.length) {
        return {
          content: [{ type: "text", text: `No hidden Pi tool matched "${params.query}". Rephrase the capability narrowly. For MCP capabilities, use the mcp gateway search instead.` }],
          details: { query: params.query, matches: [], added: [] }
        };
      }

      const added = [];
      for (const { tool } of candidates) {
        if (!active.has(tool.name)) {
          discovered.add(tool.name);
          added.push(tool.name);
        }
      }
      applyGate();

      const text = candidates
        .map(({ tool, score }) => `${tool.name} (${score.toFixed(2)}): ${String(tool.description || "").slice(0, 220)}`)
        .join("\n");
      return {
        content: [{ type: "text", text: `Activated ${added.length} tool(s): ${added.join(", ")}\n${text}` }],
        details: { query: params.query, matches: candidates.map((x) => x.tool.name), added }
      };
    }
  });

  pi.on("session_start", () => {
    discovered.clear();
    applyGate();
  });

  pi.on("before_agent_start", () => {
    applyGate();
  });

  pi.registerCommand("tool-gate", {
    description: "Show/reset the deferred tool gate: /tool-gate [status|reset|all]",
    handler: async (args, ctx) => {
      const op = String(args || "status").trim().toLowerCase();
      if (op === "reset") {
        discovered.clear();
        applyGate();
      } else if (op === "all") {
        for (const t of pi.getAllTools()) if (!BASE_TOOLS.includes(t.name)) discovered.add(t.name);
        applyGate();
      }
      ctx.ui.notify(`Tools: ${pi.getActiveTools().length} active / ${pi.getAllTools().length} registered`, "info");
    }
  });
}
