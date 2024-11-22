#!/bin/bash

# Directory to save through the commit history
HISTORY_DIR="btc_price_history"
mkdir -p "$HISTORY_DIR"

# Fetch all commits that modified the target file, in chronological order
git log --pretty=format:"%H %ct" --reverse -- btc-price-postprocessed.json | while read -r commit_hash commit_timestamp
do
    # Convert Unix timestamp to readable date format on macOS
    commit_date=$(date -r "$commit_timestamp" +"%Y%m%d_%H%M%S")
    
    # Define the output filename
    output_file="${HISTORY_DIR}/btc-price-postprocessed_${commit_date}.json"
    
    # Check if the file already exists to avoid duplicates
    if [ -f "$output_file" ]; then
        echo "Skipping commit ${commit_hash} (${commit_date}) - already exists."
        continue
    fi

    # Extract the file content at the specific commit
    git show "${commit_hash}:btc-price-postprocessed.json" > "$output_file"
    
    # Check if git show was successful
    if [ $? -eq 0 ]; then
        echo "Saved version from commit ${commit_hash} at ${commit_date}"
    else
        echo "Failed to save version from commit ${commit_hash}"
    fi
done

echo "Historical extraction complete. Check the '${HISTORY_DIR}' directory."
