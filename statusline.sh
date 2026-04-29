#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "..."' | sed 's/ ([^)]*context)//')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "..."' | xargs basename)
session_id=$(echo "$input" | jq -r '.session_id // "..."')
claude_pid=$PPID
script_pid=$$
parent_parent_pid=$(ps -o ppid= -p "$claude_pid" 2>/dev/null | tr -d ' ')

# Load theme from config (default: mocha)
STATUSLINE_THEME="mocha"
if [ -n "${STATUSLINE_CONF:-}" ] && [ -f "$STATUSLINE_CONF" ]; then
    theme_config="$STATUSLINE_CONF"
elif [ -f "${HOME}/.cursor/statusline.conf" ]; then
    theme_config="${HOME}/.cursor/statusline.conf"
else
    theme_config="${HOME}/.claude/statusline.conf"
fi
[ -f "$theme_config" ] && . "$theme_config"

# Catppuccin palette — full accent colors (canonical rainbow order)
R='\033[0m'
case "$STATUSLINE_THEME" in
    latte)
        BG_ROSEWATER='\033[48;2;220;138;120m'
        BG_FLAMINGO='\033[48;2;221;120;120m'
        BG_PINK='\033[48;2;234;118;203m'
        BG_MAUVE='\033[48;2;136;57;239m'
        BG_RED='\033[48;2;210;15;57m'
        BG_MAROON='\033[48;2;230;69;83m'
        BG_PEACH='\033[48;2;254;100;11m'
        BG_YELLOW='\033[48;2;223;142;29m'
        BG_GREEN='\033[48;2;64;160;43m'
        BG_TEAL='\033[48;2;23;146;153m'
        BG_SKY='\033[48;2;4;165;229m'
        BG_SAPPHIRE='\033[48;2;32;159;181m'
        BG_BLUE='\033[48;2;30;102;245m'
        BG_LAVENDER='\033[48;2;114;135;253m'
        FG_CRUST='\033[38;2;239;241;245m'
        FG_ROSEWATER='\033[38;2;220;138;120m'
        FG_FLAMINGO='\033[38;2;221;120;120m'
        FG_PINK='\033[38;2;234;118;203m'
        FG_MAUVE='\033[38;2;136;57;239m'
        FG_RED='\033[38;2;210;15;57m'
        FG_MAROON='\033[38;2;230;69;83m'
        FG_PEACH='\033[38;2;254;100;11m'
        FG_YELLOW='\033[38;2;223;142;29m'
        FG_GREEN='\033[38;2;64;160;43m'
        FG_TEAL='\033[38;2;23;146;153m'
        FG_SKY='\033[38;2;4;165;229m'
        FG_SAPPHIRE='\033[38;2;32;159;181m'
        FG_BLUE='\033[38;2;30;102;245m'
        FG_LAVENDER='\033[38;2;114;135;253m'
        ;;
    frappe)
        BG_ROSEWATER='\033[48;2;242;213;207m'
        BG_FLAMINGO='\033[48;2;238;190;190m'
        BG_PINK='\033[48;2;244;184;228m'
        BG_MAUVE='\033[48;2;202;158;230m'
        BG_RED='\033[48;2;231;130;132m'
        BG_MAROON='\033[48;2;234;153;156m'
        BG_PEACH='\033[48;2;239;159;118m'
        BG_YELLOW='\033[48;2;229;200;144m'
        BG_GREEN='\033[48;2;166;209;137m'
        BG_TEAL='\033[48;2;129;200;190m'
        BG_SKY='\033[48;2;153;209;219m'
        BG_SAPPHIRE='\033[48;2;133;193;220m'
        BG_BLUE='\033[48;2;140;170;238m'
        BG_LAVENDER='\033[48;2;186;187;241m'
        FG_CRUST='\033[38;2;35;38;52m'
        FG_ROSEWATER='\033[38;2;242;213;207m'
        FG_FLAMINGO='\033[38;2;238;190;190m'
        FG_PINK='\033[38;2;244;184;228m'
        FG_MAUVE='\033[38;2;202;158;230m'
        FG_RED='\033[38;2;231;130;132m'
        FG_MAROON='\033[38;2;234;153;156m'
        FG_PEACH='\033[38;2;239;159;118m'
        FG_YELLOW='\033[38;2;229;200;144m'
        FG_GREEN='\033[38;2;166;209;137m'
        FG_TEAL='\033[38;2;129;200;190m'
        FG_SKY='\033[38;2;153;209;219m'
        FG_SAPPHIRE='\033[38;2;133;193;220m'
        FG_BLUE='\033[38;2;140;170;238m'
        FG_LAVENDER='\033[38;2;186;187;241m'
        ;;
    macchiato)
        BG_ROSEWATER='\033[48;2;244;219;214m'
        BG_FLAMINGO='\033[48;2;240;198;198m'
        BG_PINK='\033[48;2;245;189;230m'
        BG_MAUVE='\033[48;2;198;160;246m'
        BG_RED='\033[48;2;237;135;150m'
        BG_MAROON='\033[48;2;238;153;160m'
        BG_PEACH='\033[48;2;245;169;127m'
        BG_YELLOW='\033[48;2;238;212;159m'
        BG_GREEN='\033[48;2;166;218;149m'
        BG_TEAL='\033[48;2;139;213;202m'
        BG_SKY='\033[48;2;145;215;227m'
        BG_SAPPHIRE='\033[48;2;125;196;228m'
        BG_BLUE='\033[48;2;138;173;244m'
        BG_LAVENDER='\033[48;2;183;189;248m'
        FG_CRUST='\033[38;2;24;25;38m'
        FG_ROSEWATER='\033[38;2;244;219;214m'
        FG_FLAMINGO='\033[38;2;240;198;198m'
        FG_PINK='\033[38;2;245;189;230m'
        FG_MAUVE='\033[38;2;198;160;246m'
        FG_RED='\033[38;2;237;135;150m'
        FG_MAROON='\033[38;2;238;153;160m'
        FG_PEACH='\033[38;2;245;169;127m'
        FG_YELLOW='\033[38;2;238;212;159m'
        FG_GREEN='\033[38;2;166;218;149m'
        FG_TEAL='\033[38;2;139;213;202m'
        FG_SKY='\033[38;2;145;215;227m'
        FG_SAPPHIRE='\033[38;2;125;196;228m'
        FG_BLUE='\033[38;2;138;173;244m'
        FG_LAVENDER='\033[38;2;183;189;248m'
        ;;
    mocha|*)
        BG_ROSEWATER='\033[48;2;245;224;220m'
        BG_FLAMINGO='\033[48;2;242;205;205m'
        BG_PINK='\033[48;2;245;194;231m'
        BG_MAUVE='\033[48;2;203;166;247m'
        BG_RED='\033[48;2;243;139;168m'
        BG_MAROON='\033[48;2;235;160;172m'
        BG_PEACH='\033[48;2;250;179;135m'
        BG_YELLOW='\033[48;2;249;226;175m'
        BG_GREEN='\033[48;2;166;227;161m'
        BG_TEAL='\033[48;2;148;226;213m'
        BG_SKY='\033[48;2;137;220;235m'
        BG_SAPPHIRE='\033[48;2;116;199;236m'
        BG_BLUE='\033[48;2;137;180;250m'
        BG_LAVENDER='\033[48;2;180;190;254m'
        FG_CRUST='\033[38;2;17;17;27m'
        FG_ROSEWATER='\033[38;2;245;224;220m'
        FG_FLAMINGO='\033[38;2;242;205;205m'
        FG_PINK='\033[38;2;245;194;231m'
        FG_MAUVE='\033[38;2;203;166;247m'
        FG_RED='\033[38;2;243;139;168m'
        FG_MAROON='\033[38;2;235;160;172m'
        FG_PEACH='\033[38;2;250;179;135m'
        FG_YELLOW='\033[38;2;249;226;175m'
        FG_GREEN='\033[38;2;166;227;161m'
        FG_TEAL='\033[38;2;148;226;213m'
        FG_SKY='\033[38;2;137;220;235m'
        FG_SAPPHIRE='\033[38;2;116;199;236m'
        FG_BLUE='\033[38;2;137;180;250m'
        FG_LAVENDER='\033[38;2;180;190;254m'
        ;;
esac

# Powerline characters
PL=$(printf '\xee\x82\xb0')       # U+E0B0 right arrow (segment transition)
PL_OPEN=$(printf '\xee\x82\xb6')  # U+E0B6 left  half-circle (opening cap)
PL_CLOSE=$(printf '\xee\x82\xb4') # U+E0B4 right half-circle (closing cap)

# Nerd font icons
ctx_icon=$(printf '\xf3\xb0\xa7\x91')    # 󰧑
peers_icon=$(printf '\xf3\xb0\xa1\x89')  # agents/group
tok_icon=$(printf '\xe2\x87\x85')         # ⇅ token I/O
time_icon=$(printf '\xf3\xb0\x8a\x9a')   # 󰊚 nerd font clock/time

fmt_tokens() {
    python3 -c "
def fmt(n):
    n=int(float(n))
    if n>=1_000_000: return f'{n/1_000_000:.1f}M'
    if n>=1_000: return f'{round(n/1000)}k'
    return str(n)
print(f'↓{fmt(\"$1\")} ↑{fmt(\"$2\")}')
" 2>/dev/null
}

format_time() {
    [ -z "$1" ] || [ "$1" = "null" ] && return
    python3 -c "
import sys
from datetime import datetime
h='$1'.strip()
if not h or h=='null': sys.exit(0)
try:
    v=float(h)
    if v>1e12: v/=1000.0
    if 0<v<1e12:
        print(datetime.fromtimestamp(v).strftime('%H:%M'),end='')
        sys.exit(0)
except: pass
s=h[:-1]+'+00:00' if h.endswith('Z') else h
try:
    d=datetime.fromisoformat(s)
    if d.tzinfo: d=d.astimezone()
    print(d.strftime('%H:%M'),end='')
except: pass
" 2>/dev/null
}

format_datetime() {
    [ -z "$1" ] || [ "$1" = "null" ] && return
    python3 -c "
import sys
from datetime import datetime
h='$1'.strip()
if not h or h=='null': sys.exit(0)
try:
    v=float(h)
    if v>1e12: v/=1000.0
    if 0<v<1e12:
        print(datetime.fromtimestamp(v).strftime('%a %H:%M'),end='')
        sys.exit(0)
except: pass
s=h[:-1]+'+00:00' if h.endswith('Z') else h
try:
    d=datetime.fromisoformat(s)
    if d.tzinfo: d=d.astimezone()
    print(d.strftime('%a %H:%M'),end='')
except: pass
" 2>/dev/null
}

iso_to_epoch() {
    local iso="$1" epoch=""
    epoch=$(date -d "${iso}" +%s 2>/dev/null)
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    local s="${iso%%.*}"; s="${s%%Z}"; s="${s%%+*}"; s="${s%%-[0-9][0-9]:[0-9][0-9]}"
    if [[ "$iso" == *"Z"* ]] || [[ "$iso" == *"+00:00"* ]]; then
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$s" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$s" +%s 2>/dev/null)
    fi
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    return 1
}

# Git
branch="" in_git=false
if git rev-parse --git-dir > /dev/null 2>&1; then
    in_git=true
    branch=$(git branch --show-current 2>/dev/null)
fi

# Tokens from stdin
ct_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ct_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
token_display=""
if [ -n "$ct_in" ] && [ "$ct_in" != "null" ] && [ -n "$ct_out" ] && [ "$ct_out" != "null" ]; then
    token_display=$(fmt_tokens "$ct_in" "$ct_out")
fi

# Agents (Square)
square_agents=""
nicknames_file="/tmp/agent-square/nicknames.json"
if [ -f "$nicknames_file" ]; then
    for pid in "$claude_pid" "$script_pid" "$parent_parent_pid"; do
        [ -n "$pid" ] || continue
        square_peers=$(jq -r --arg pid "$pid" '.[$pid].peers // empty' "$nicknames_file" 2>/dev/null)
        if [ -n "$square_peers" ]; then
            square_agents=$((square_peers + 1))
            break
        fi
    done
fi

# RTK savings (cached 60s)
rtk_cache="/tmp/claude/rtk-savings-cache.txt"
mkdir -p /tmp/claude
rtk_display=""
needs_rtk=true
if [ -f "$rtk_cache" ]; then
    cache_mtime=$(stat -f %m "$rtk_cache" 2>/dev/null || stat -c %Y "$rtk_cache" 2>/dev/null)
    now=$(date +%s)
    [ $(( now - cache_mtime )) -lt 60 ] && needs_rtk=false && rtk_display=$(cat "$rtk_cache" 2>/dev/null)
fi
if $needs_rtk; then
    rtk_display=$(timeout 3 rtk gain 2>/dev/null | \
        grep -i "Tokens saved:" | \
        grep -oE '[0-9]+\.[0-9]+[KMk]|[0-9]+[KMk]|[0-9,]+' | \
        head -1 | tr '[:upper:]' '[:lower:]')
    echo "$rtk_display" > "$rtk_cache"
fi

# Rate limit data
has_stdin_rates=false
five_hour_pct="" five_hour_raw="" seven_day_pct="" seven_day_raw=""

stdin_five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$stdin_five_pct" ]; then
    has_stdin_rates=true
    five_hour_pct=$(printf "%.0f" "$stdin_five_pct")
    five_hour_raw=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
    seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' | awk '{printf "%.0f", $1}')
    seven_day_raw=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
fi

cache_file="/tmp/claude/statusline-usage-cache.json"
usage_data=""

if ! $has_stdin_rates; then
    needs_refresh=true
    if [ -f "$cache_file" ]; then
        cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
        now=$(date +%s)
        [ $(( now - cache_mtime )) -lt 60 ] && needs_refresh=false && usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
    if $needs_refresh; then
        token=""
        [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ] && token="$CLAUDE_CODE_OAUTH_TOKEN"
        if [ -z "$token" ] && command -v security >/dev/null 2>&1; then
            blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
            [ -n "$blob" ] && token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
        fi
        if [ -z "$token" ] || [ "$token" = "null" ]; then
            creds_file="${HOME}/.claude/.credentials.json"
            [ -f "$creds_file" ] && token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        fi
        if [ -n "$token" ] && [ "$token" != "null" ]; then
            response=$(curl -s --max-time 5 \
                -H "Accept: application/json" -H "Content-Type: application/json" \
                -H "Authorization: Bearer $token" \
                -H "anthropic-beta: oauth-2025-04-20" \
                -H "User-Agent: claude-code/2.1.34" \
                "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
            if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
                usage_data="$response"
                echo "$response" > "$cache_file"
            fi
        fi
        [ -z "$usage_data" ] && [ -f "$cache_file" ] && usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
    if [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
        five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
        five_hour_raw=$(iso_to_epoch "$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')")
        seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
        seven_day_raw=$(iso_to_epoch "$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')")
    fi
fi

# ── Collect active segment texts ──────────────────────────────────────────────
seg_texts=()

seg_texts+=("${model} ${ctx_icon} ${context_pct}%")

if [ -n "$five_hour_pct" ]; then
    five_h_time=$(format_time "$five_hour_raw")
    rate_txt="5h ${five_hour_pct}%"
    [ -n "$five_h_time" ] && rate_txt+=" ${time_icon} ${five_h_time}"
    if [ -n "$seven_day_pct" ]; then
        seven_d_time=$(format_datetime "$seven_day_raw")
        rate_txt+=" 7d ${seven_day_pct}%"
        [ -n "$seven_d_time" ] && rate_txt+=" ${time_icon} ${seven_d_time}"
    fi
    seg_texts+=("$rate_txt")
fi

seg_texts+=("󰉖 ${current_dir}")

$in_git && [ -n "$branch" ] && seg_texts+=("󰘬 ${branch}")
[ -n "$square_agents" ]      && seg_texts+=("${peers_icon} ${square_agents} agents")
[ -n "$rtk_display" ]        && seg_texts+=("rtk ${rtk_display}")
[ -n "$token_display" ]      && seg_texts+=("${tok_icon} ${token_display}")

# ── Rainbow palette (Catppuccin Mocha canonical order) ────────────────────────
rainbow_bg=(
    "$BG_ROSEWATER" "$BG_FLAMINGO" "$BG_PINK"    "$BG_MAUVE"
    "$BG_RED"       "$BG_MAROON"   "$BG_PEACH"   "$BG_YELLOW"
    "$BG_GREEN"     "$BG_TEAL"     "$BG_SKY"     "$BG_SAPPHIRE"
    "$BG_BLUE"      "$BG_LAVENDER"
)
rainbow_fg=(
    "$FG_ROSEWATER" "$FG_FLAMINGO" "$FG_PINK"    "$FG_MAUVE"
    "$FG_RED"       "$FG_MAROON"   "$FG_PEACH"   "$FG_YELLOW"
    "$FG_GREEN"     "$FG_TEAL"     "$FG_SKY"     "$FG_SAPPHIRE"
    "$FG_BLUE"      "$FG_LAVENDER"
)

# Evenly distribute 14 colors across n segments (first=index 0, last=index 13)
n_segs=${#seg_texts[@]}
read -ra color_indices <<< "$(python3 -c "
n=$n_segs
for i in range(n):
    print(round(i*13/max(n-1,1)), end=' ')
")"

# 3 ghost-step indices: evenly spaced between second-to-last and last color index
ghost_ci=()
if [ "$n_segs" -ge 2 ]; then
    read -ra ghost_ci <<< "$(python3 -c "
p,l=${color_indices[$((n_segs-2))]},${color_indices[$((n_segs-1))]}
print(round(p+(l-p)/4), round(p+(l-p)*2/4), round(p+(l-p)*3/4))
")"
fi

# ── Render ────────────────────────────────────────────────────────────────────
_is_first=true
_prev_fg=""
_line=""
last_idx=$((n_segs - 1))

for i in "${!seg_texts[@]}"; do
    ci="${color_indices[$i]}"
    bg="${rainbow_bg[$ci]}"
    fg="${rainbow_fg[$ci]}"
    text="${seg_texts[$i]}"

    # 3 ghost steps just before the last segment
    if [ "$i" -eq "$last_idx" ] && [ "${#ghost_ci[@]}" -eq 3 ]; then
        for gci in "${ghost_ci[@]}"; do
            gbg="${rainbow_bg[$gci]}"
            gfg="${rainbow_fg[$gci]}"
            _line+="${R}${_prev_fg}${gbg}${PL}${gbg} "
            _prev_fg="$gfg"
        done
    fi

    if $_is_first; then
        _line+="${R}${fg}${PL_OPEN}"
        _is_first=false
    else
        _line+="${R}${_prev_fg}${bg}${PL}"
    fi
    _line+="${bg}${FG_CRUST}  ${text}  "
    _prev_fg="$fg"
done

_line+="${R}${_prev_fg}${PL_CLOSE}${R}"
printf "%b\n" "$_line"
