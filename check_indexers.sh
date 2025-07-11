#!/bin/bash
   LOG_FILE="${LOG_PATH:-/home/asus/media-server/logs}/indexer_check.log"
   PROWLARR_URL="http://${SERVER_IP:-localhost}:9696"
   PROWLARR_API_KEY="${PROWLARR_API_KEY:-YOUR_PROWLARR_API_KEY}"
   TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
   mkdir -p "$(dirname "$LOG_FILE")"

   RESPONSE=$(curl -s -H "X-Api-Key: $PROWLARR_API_KEY" "$PROWLARR_URL/api/v1/indexerstatus")
   if [ $? -ne 0 ]; then
     echo "[$TIMESTAMP] ERROR: Failed to connect to Prowlarr API at $PROWLARR_URL" >> "$LOG_FILE"
     exit 1
   fi

   INDEXERS=$(echo "$RESPONSE" | jq -r '.[] | "\(.indexer): \(.lastSync) (\(.reason))"')
   if [ -z "$INDEXERS" ]; then
     echo "[$TIMESTAMP] ERROR: No indexers found or API error" >> "$LOG_FILE"
   else
     while IFS= read -r line; do
       if echo "$line" | grep -q "Failed"; then
         echo "[$TIMESTAMP] ERROR: Indexer $line" >> "$LOG_FILE"
       else
         echo "[$TIMESTAMP] Indexer $line is UP" >> "$LOG_FILE"
       fi
     done <<< "$INDEXERS"
   fi