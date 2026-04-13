# MCP Server Configuration Examples

> These are examples of how to add MCP servers to your Claude Code setup.
> Use `claude mcp add` command - never edit the JSON config directly.

## Supabase (per project)

```bash
# Add a Supabase MCP for your project
claude mcp add supabase-myproject \
  --command "npx" \
  --args "-y @supabase/mcp-server" \
  --env "SUPABASE_URL=https://xxxxx.supabase.co" \
  --env "SUPABASE_SERVICE_ROLE_KEY=your-key-here"
```

## Obsidian (knowledge base)

```bash
claude mcp add obsidian \
  --command "npx" \
  --args "-y obsidian-mcp-server" \
  --env "VAULT_PATH=/path/to/your/vault"
```

## Browser (Playwright MCP)

```bash
claude mcp add browser \
  --command "npx" \
  --args "-y @anthropic/mcp-browser"
```

## SSH (VPS access)

```bash
claude mcp add ssh-myserver \
  --command "npx" \
  --args "-y ssh-mcp-server" \
  --env "SSH_HOST=your-server-ip" \
  --env "SSH_USER=root" \
  --env "SSH_KEY_PATH=~/.ssh/id_rsa"
```

## Figma

```bash
claude mcp add figma \
  --command "npx" \
  --args "-y @anthropic/mcp-figma" \
  --env "FIGMA_ACCESS_TOKEN=your-token"
```

## PostHog (analytics)

```bash
claude mcp add posthog \
  --command "npx" \
  --args "-y posthog-mcp-server" \
  --env "POSTHOG_API_KEY=your-key" \
  --env "POSTHOG_HOST=https://app.posthog.com"
```

## Context7 (library docs)

```bash
claude mcp add context7 \
  --command "npx" \
  --args "-y @context7/mcp-server"
```

## Tips

- Each project can have its own Supabase/SSH MCP instances
- Name them descriptively: `supabase-myapp`, `ssh-production`, `ssh-staging`
- Store secrets in environment variables, not in command args
- Use `claude mcp list` to see all configured servers
- Use `claude mcp remove <name>` to remove a server
