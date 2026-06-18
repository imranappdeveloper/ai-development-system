#!/usr/bin/env bash
# bind-project.sh — alias for ai-new on current folder (existing projects)
_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$_dir/new-project.sh" .