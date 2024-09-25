#!/bin/bash

# Path to your original CSV file
CSV_FILE="source_wp_users.csv"
# Path to the new CSV file that will include dummy entries
NEW_CSV_FILE="source_wp_users_with_dummies.csv"

# Start the new CSV file with the header
echo "ID,user_name,user_email" > "$NEW_CSV_FILE"

# Initialize variables
expected_id=3
dummy_count=1
gaps_found=false

# Read the original CSV file without sorting to preserve the original order
tail -n +2 "$CSV_FILE" | while IFS=',' read -r id user_login user_email; do
    while (( expected_id < id )); do
        # Create a dummy entry to fill the gap
        dummy_user="dummy$dummy_count"
        dummy_email="dummy$dummy_count@tellermitte-redesign.de"
        echo "$expected_id,$dummy_user,$dummy_email" >> "$NEW_CSV_FILE"
        echo "Gap detected: Added $dummy_user with ID $expected_id"
        ((dummy_count++))
        ((expected_id++))
        gaps_found=true
    done

    # Add the current entry to the new CSV file
    echo "$id,$user_login,$user_email" >> "$NEW_CSV_FILE"
    ((expected_id++))
done

# If no gaps were found
if ! $gaps_found; then
    echo "No gaps found. IDs were consecutive starting from 3."
else
    echo "New CSV file created with dummy entries: $NEW_CSV_FILE"
fi

