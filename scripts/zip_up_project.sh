#!/bin/bash

# Resolve script's directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT" || { echo "Error: Unable to navigate to project root"; exit 1; }

# Variables
PROJECT_DIR="$(basename "$PROJECT_ROOT")"
OUTPUTS_DIR="$PROJECT_ROOT/outputs"
TIMESTAMP=$(date +"%Y%m%d%H%M")
ZIP_FILE="$OUTPUTS_DIR/${PROJECT_DIR}_$TIMESTAMP.zip"

# Exclusions
EXCLUDE_PATTERNS=(
    "*.DS_Store"
    ".aws-sam/*"
    "outputs/*"
    "__pycache__/*"
    ".venv/*"
    "node_modules/*"
    ".parcel-cache/*"
    "build/*"
    "dist/*"
)

# Function to verify the presence of the zip executable
check_zip() {
    echo "Verifying zip command availability..."
    if ! command -v zip &>/dev/null; then
        echo "Error: zip is not installed. Please install it and try again."
        exit 1
    fi
}

# Function to create the outputs directory if it does not exist
create_outputs_dir() {
    if [ ! -d "$OUTPUTS_DIR" ]; then
        echo "Creating outputs directory..."
        mkdir -p "$OUTPUTS_DIR" || { echo "Error: Failed to create outputs directory"; exit 1; }
    fi
}

# Function to create the zip file
create_zip_file() {
    echo "Creating zip file $ZIP_FILE..."
    EXCLUDE_ARGS=()
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        EXCLUDE_ARGS+=("-x" "$pattern")
    done
    zip -r "$ZIP_FILE" . "${EXCLUDE_ARGS[@]}" || { echo "Error: Failed to create zip file"; exit 1; }
}

# Function to verify the zip file creation
verify_zip_file() {
    if [ -f "$ZIP_FILE" ]; then
        echo "Zip file created successfully: $ZIP_FILE"
    else
        echo "Error: Zip file creation failed."
        exit 1
    fi
}

# Main execution flow
check_zip
create_outputs_dir
create_zip_file
verify_zip_file
echo "Script completed successfully."
