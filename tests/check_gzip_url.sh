#!/bin/bash

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"

# Temporary file to hold the list of URLs to check
URL_LIST=$(mktemp)

# Use wget to download the page and extract URLs of resources
wget -qO- "$URL" | grep -oP '(?<=href=")[^"]*' | grep -E '\.(css|js|jpg|jpeg|png|svg|woff|woff2|json|xml)$' | sed "s|^/|$URL/|" > $URL_LIST
wget -qO- "$URL" | grep -oP '(?<=src=")[^"]*' | grep -E '\.(css|js|jpg|jpeg|png|svg|woff|woff2|json|xml)$' | sed "s|^/|$URL/|" >> $URL_LIST

# Removing duplicates
sort $URL_LIST | uniq > ${URL_LIST}_tmp
mv ${URL_LIST}_tmp $URL_LIST

# Check each URL in the list for GZIP compression
while IFS= read -r file_url; do
    echo -n "Checking $file_url ... "
    if curl -s -I -H "Accept-Encoding: gzip, deflate, br" "$file_url" | grep -qi "Content-Encoding: gzip"; then
        echo "GZIP Enabled"
    else
        echo "GZIP Not Enabled"
    fi
done < $URL_LIST

# Clean up
rm $URL_LIST
