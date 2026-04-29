#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const VALID_THEMES = ['mocha', 'latte', 'frappe', 'macchiato'];

const args = process.argv.slice(2);
const themeFlag = args.indexOf('--theme');
const theme = themeFlag !== -1 ? args[themeFlag + 1] : 'mocha';
const targetFlag = args.indexOf('--target');
let target = targetFlag !== -1 ? args[targetFlag + 1] : 'claude';
if (target === undefined || !['claude', 'cursor', 'both'].includes(target)) {
  console.error(
    'Error: --target must be claude, cursor, or both (e.g. --target cursor)',
  );
  process.exit(1);
}

if (!VALID_THEMES.includes(theme)) {
  console.error(`Error: unknown theme "${theme}". Valid options: ${VALID_THEMES.join(', ')}`);
  process.exit(1);
}

const homedir = os.homedir();
const claudeDir = path.join(homedir, '.claude');
const cursorDir = path.join(homedir, '.cursor');
const settingsPath = path.join(claudeDir, 'settings.json');
const cursorCliConfigPath = path.join(cursorDir, 'cli-config.json');
const srcScript = path.join(__dirname, '..', 'statusline.sh');

const appLabel =
  target === 'both'
    ? 'Claude Code + Cursor CLI'
    : target === 'cursor'
      ? 'Cursor CLI'
      : 'Claude Code';

console.log(`${appLabel} Status Pills — Catppuccin ${theme.charAt(0).toUpperCase() + theme.slice(1)}`);
console.log('='.repeat(50) + '\n');

if (!fs.existsSync(srcScript)) {
  console.error('Error: statusline.sh not found in package. Installation aborted.');
  process.exit(1);
}

function installToClaude() {
  const confPath = path.join(claudeDir, 'statusline.conf');
  const destScript = path.join(claudeDir, 'statusline.sh');

  if (!fs.existsSync(claudeDir)) {
    fs.mkdirSync(claudeDir, { recursive: true });
  }

  fs.copyFileSync(srcScript, destScript);
  fs.chmodSync(destScript, 0o755);
  console.log(`✓ Script installed → ${destScript}`);

  fs.writeFileSync(confPath, `STATUSLINE_THEME=${theme}\n`);
  console.log(`✓ Theme saved      → ${confPath} (${theme})`);

  let settings = {};
  if (fs.existsSync(settingsPath)) {
    try {
      settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
    } catch {
      console.warn('Warning: Could not parse existing settings.json — starting fresh.');
    }
  }

  settings.statusLine = {
    type: 'command',
    command: '~/.claude/statusline.sh',
    padding: 0,
  };

  fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n');
  console.log(`✓ Settings updated → ${settingsPath}`);
}

function installToCursor() {
  const confPath = path.join(cursorDir, 'statusline.conf');
  const destScript = path.join(cursorDir, 'statusline.sh');

  if (!fs.existsSync(cursorDir)) {
    fs.mkdirSync(cursorDir, { recursive: true });
  }

  fs.copyFileSync(srcScript, destScript);
  fs.chmodSync(destScript, 0o755);
  console.log(`✓ Script installed → ${destScript}`);

  fs.writeFileSync(confPath, `STATUSLINE_THEME=${theme}\n`);
  console.log(`✓ Theme saved      → ${confPath} (${theme})`);

  let cliConfig = {};
  if (fs.existsSync(cursorCliConfigPath)) {
    try {
      cliConfig = JSON.parse(fs.readFileSync(cursorCliConfigPath, 'utf8'));
    } catch {
      console.warn('Warning: Could not parse existing cli-config.json — starting fresh.');
    }
  }

  cliConfig.statusLine = {
    type: 'command',
    command: '~/.cursor/statusline.sh',
    padding: 2,
  };

  fs.writeFileSync(cursorCliConfigPath, JSON.stringify(cliConfig, null, 2) + '\n');
  console.log(`✓ Settings updated → ${cursorCliConfigPath}`);
}

if (target === 'claude' || target === 'both') {
  installToClaude();
  if (target === 'both') console.log('');
}
if (target === 'cursor' || target === 'both') {
  installToCursor();
}

const restartHint =
  target === 'both'
    ? 'Restart Claude Code and the Cursor CLI to see the status line.'
    : target === 'cursor'
      ? 'Restart the Cursor CLI (or open a new terminal session) to see the status line.'
      : 'Restart Claude Code to see the statusline.';
console.log(`\n${restartHint}`);
