#!/bin/bash -l

# Start from the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Search for the project root by looking for a marker file or directory (e.g., .git)
find_project_root() {
    dir="$1"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" || -f "$dir/pyproject.toml" || -f "$dir/setup.py" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

PROJECT_ROOT=$(find_project_root "$SCRIPT_DIR")
if [[ -z "$PROJECT_ROOT" ]]; then
    echo "Error: Could not find project root."
    exit 1
fi


./atria_metrics/scripts/build_registry.sh
./atria_models/scripts/build_registry.sh
./atria_transforms/scripts/build_registry.sh
./atria_datasets/scripts/build_registry.sh
./atria_ml/scripts/build_registry.sh