#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const claudeDir = path.join(os.homedir(), '.claude');
const settingsPath = path.join(claudeDir, 'settings.json');
const destScript = path.join(claudeDir, 'statusline.sh');
const srcScript = path.join(__dirname, '..', 'statusline.sh');

console.log('Claude Code Statusline — Catppuccin Mocha');
console.log('==========================================\n');

if (!fs.existsSync(srcScript)) {
  console.error('Error: statusline.sh not found in package. Installation aborted.');
  process.exit(1);
}

if (!fs.existsSync(claudeDir)) {
  fs.mkdirSync(claudeDir, { recursive: true });
}

fs.copyFileSync(srcScript, destScript);
fs.chmodSync(destScript, 0o755);
console.log(`✓ Script installed → ${destScript}`);

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
console.log(`✓ Settings updated  → ${settingsPath}`);
console.log('\nRestart Claude Code to see the statusline.');
