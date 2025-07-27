#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run openapi-python-client with output in the script's directory
uv run openapi-python-client generate \
    --url http://127.0.0.1:8080/api/v1/openapi.json \
    --output-path "$SCRIPT_DIR/atriax_client/" \
    --overwrite