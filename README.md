Media Server Setup
   A Docker-based media server with Homepage dashboard, Jellyfin for streaming, Jellyseerr for content requests, Sonarr and Radarr for automated TV and movie downloads, qBittorrent for torrenting, Prowlarr for indexer management, and FlareSolverr for proxy support.
Features

Centralized dashboard (Homepage) at http://<your-ip>:3000
Local-only access for streaming and automation
Configurable via environment variables
Cron jobs to monitor Cloudflare WARP and indexer health
Inspired by a clean, dark-themed layout

Prerequisites

Docker and Docker Compose (sudo apt install docker.io docker-compose)
Ubuntu-based OS (tested on Lubuntu 25.04)
Media storage directory (e.g., /media/movies, /media/shows)
Torrent download directory (e.g., /torrents)
Cloudflare WARP (sudo apt install cloudflare-warp)
jq for JSON parsing (sudo apt install jq)

Installation

Clone the repository:git clone https://github.com/yourusername/media-server.git
cd media-server


Copy .env.example to .env and configure:cp .env.example .env
nano .env


Set PUID, PGID (your user/group IDs, e.g., id -u, id -g)
Set SERVER_IP (e.g., 192.168.1.254)
Set MEDIA_PATH and TORRENTS_PATH to your storage paths
Set LOG_PATH (e.g., /path/to/logs)
Set PROWLARR_API_KEY from Prowlarr (Settings > General > Security)


Create Homepage config directory:mkdir -p homepage/config


Obtain API keys and credentials:
Jellyfin: Username/password from http://<SERVER_IP>:8096
Jellyseerr: API key from Settings > General > API Key
Sonarr/Radarr/Prowlarr: API keys from Settings > General > Security
qBittorrent: Username/password from http://<SERVER_IP>:8080


Update homepage/config/services.yaml with your credentials.
Start services:docker-compose up -d


Access Homepage at http://<SERVER_IP>:3000.

Services

Homepage: Dashboard (:3000)
Jellyfin: Media streaming (:8096)
Jellyseerr: Content requests (:5055)
Sonarr: TV shows (:8989)
Radarr: Movies (:7878)
qBittorrent: Torrents (:8080)
Prowlarr: Indexers (:9696)
FlareSolverr: Proxy (:8191)

Cron Jobs
   Monitor Cloudflare WARP and indexer health every 15 minutes:

Create scripts directory:mkdir -p scripts


Copy check_warp.sh and check_indexers.sh to scripts/.
Make scripts executable:chmod +x scripts/*.sh


Set up cron jobs:crontab -e

Add:*/15 * * * * /path/to/media-server/scripts/check_warp.sh
*/15 * * * * /path/to/media-server/scripts/check_indexers.sh


Check logs:cat $LOG_PATH/warp_check.log
cat $LOG_PATH/indexer_check.log



Configuration

Edit homepage/config/services.yaml to add API keys and credentials.
Customize homepage/config/settings.yaml for layout/theme.
Adjust homepage/config/widgets.yaml for widgets (e.g., CPU, datetime).
Ensure permissions:sudo chown -R $PUID:$PGID homepage scripts logs
sudo chmod -R 755 homepage scripts logs



Troubleshooting

Check logs: docker logs <service>
Verify Docker socket: ls -l /var/run/docker.sock
Ensure PUID/PGID match your user: id
Test API connectivity, e.g.:curl -H "X-Api-Key: YOUR_SONARR_API_KEY" http://<SERVER_IP>:8989/api/v3/system/status


Verify WARP: warp-cli status

Notes

Services are local-only by default, safe for home networks.
Replace yourusername in the clone command with your GitHub username.
Optionally configure Cloudflare WARP for secure indexer traffic.

