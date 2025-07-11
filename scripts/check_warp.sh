#!/bin/bash

   LOG_FILE="${LOG_PATH:-/home/asus/media-server/logs}/warp_check.log"
   WARP_CLI="/usr/bin/warp-cli"
   TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
   mkdir -p "$(dirname "$LOG_FILE")"
   if ! [ -x "$WARP_CLI" ]; then
     echo "[$TIMESTAMP] ERROR: warp-cli not found at $WARP_CLI" >> "$LOG_FILE"
     exit 1
   fi
   WARP_STATUS=$($WARP_CLI status 2>&1)
   if echo "$WARP_STATUS" | grep -q "Connected"; then
     echo "[$TIMESTAMP] Cloudflare WARP is UP" >> "$LOG_FILE"
   else
     echo "[$TIMESTAMP] ERROR: Cloudflare WARP is DOWN: $WARP_STATUS" >> "$LOG_FILE"
   fi
   if ping -c 3 engage.cloudflareclient.com > /dev/null 2>&1; then
     echo "[$TIMESTAMP] WARP endpoint (engage.cloudflareclient.com) is reachable" >> "$LOG_FILE"
   else
     echo "[$TIMESTAMP] ERROR: WARP endpoint (engage.cloudflareclient.com) is DOWN" >> "$LOG_FILE"
   fi