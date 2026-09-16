#!/usr/bin/env bash
# PostToolUse on Edit|Write|MultiEdit. rubocop -a on the edited Ruby file, silently; remaining offences come back
# as exit 2 so they are fixed in the same turn. Silent exit 0 otherwise.
set +e
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat)
f=$(jq -r '.tool_input.file_path // ""' <<<"$input" 2>/dev/null)
[ -n "$f" ] || exit 0
cwd=$(jq -r '.cwd // ""' <<<"$input" 2>/dev/null)
root=$(git -C "${cwd:-.}" rev-parse --show-toplevel 2>/dev/null || printf '%s' "${CLAUDE_PROJECT_DIR:-}")
[ -n "$root" ] || exit 0
case "$f" in "$root"/*.rb|"$root"/*.gemspec|"$root"/Rakefile) ;; *) exit 0 ;; esac
cd "$root" || exit 0
bundle exec rubocop --version >/dev/null 2>&1 || exit 0

out=$(bundle exec rubocop -a --format simple "$f" 2>&1)
[ $? -eq 0 ] && exit 0
{ echo "rubocop offenses remain in ${f#"$root"/} after autofix:"; printf '%s\n' "$out" | grep -vE '^(Inspecting|$)' | head -40; } >&2
exit 2
