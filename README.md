# claude-status-pills

A [Catppuccin](https://github.com/catppuccin/catppuccin)-themed status bar for Claude Code. Mocha, Latte, Frappe, and Macchiato.

![status bar showing rainbow Powerline pills](.github/preview.png)

Shows model name, context window %, 5h/7d rate limits with reset times, current directory, git branch, active Square agents, RTK savings, and token I/O — all as a row of rainbow pills at the bottom of your terminal.

## Requirements

- Terminal with [Nerd Font](https://www.nerdfonts.com/) support (Powerline glyphs)
- Node.js 18+
- `jq` and `python3` on PATH

## Install

```sh
npx @mvfsilva/claude-status-pills
npx @mvfsilva/claude-status-pills --theme latte
```

Themes: `mocha` (default), `latte`, `frappe`, `macchiato`.

Copies `statusline.sh` to `~/.claude/` and saves your theme to `~/.claude/statusline.conf`. Restart Claude Code after running.

## Manual setup

1. Copy `statusline.sh` to `~/.claude/statusline.sh` and make it executable:
   ```sh
   chmod +x ~/.claude/statusline.sh
   ```

2. Pick a theme by creating `~/.claude/statusline.conf`:
   ```sh
   STATUSLINE_THEME=frappe
   ```

3. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.claude/statusline.sh",
       "padding": 0
     }
   }
   ```

4. Restart Claude Code.

## License

MIT
