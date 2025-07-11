# 🎬 Media Server Setup

A comprehensive Docker-based media server solution featuring a centralized dashboard, automated content management, and streaming capabilities. Built with Homepage dashboard, Jellyfin for streaming, Jellyseerr for content requests, Sonarr and Radarr for automated downloads, qBittorrent for torrenting, Prowlarr for indexer management, and FlareSolverr for proxy support.

## ✨ Features

- **Centralized Dashboard** - Homepage at `http://<your-ip>:3000`
- **Local-Only Access** - Secure streaming and automation within your network
- **Environment Configuration** - Easy setup via environment variables
- **Automated Monitoring** - Cron jobs for Cloudflare WARP and indexer health
- **Clean Dark Theme** - Modern, intuitive interface design

## 📋 Prerequisites

Before getting started, ensure you have the following installed:

- **Docker & Docker Compose**

  ```bash
  sudo apt install docker.io docker-compose
  ```

- **Ubuntu-based OS** (tested on Lubuntu 25.04)

- **Storage Directories**

  - Media storage: `/media/movies`, `/media/shows`
  - Torrent downloads: `/torrents`

- **Additional Tools**
  ```bash
  sudo apt install cloudflare-warp jq
  ```

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/media-server.git
cd media-server
```

### 2. Environment Configuration

```bash
cp .env.example .env
nano .env
```

Configure the following variables:

- `PUID`, `PGID` - Your user/group IDs (`id -u`, `id -g`)
- `SERVER_IP` - Your server IP (e.g., `192.168.1.254`)
- `MEDIA_PATH` - Path to your media storage
- `TORRENTS_PATH` - Path to your torrent downloads
- `LOG_PATH` - Path for log files
- `PROWLARR_API_KEY` - From Prowlarr Settings > General > Security

### 3. Setup Homepage Configuration

```bash
mkdir -p homepage/config
```

### 4. Obtain API Keys and Credentials

| Service                    | Location                      | Path              |
| -------------------------- | ----------------------------- | ----------------- |
| **Jellyfin**               | `http://<SERVER_IP>:8096`     | Username/Password |
| **Jellyseerr**             | Settings > General            | API Key           |
| **Sonarr/Radarr/Prowlarr** | Settings > General > Security | API Keys          |
| **qBittorrent**            | `http://<SERVER_IP>:8080`     | Username/Password |

### 5. Configure Services

Update `homepage/config/services.yaml` with your credentials and API keys.

### 6. Launch Services

```bash
docker-compose up -d
```

### 7. Access Dashboard

Navigate to `http://<SERVER_IP>:3000` to access your media server dashboard.

## 🛠️ Services Overview

| Service          | Purpose            | Port | URL                       |
| ---------------- | ------------------ | ---- | ------------------------- |
| **Homepage**     | Dashboard          | 3000 | `http://<SERVER_IP>:3000` |
| **Jellyfin**     | Media Streaming    | 8096 | `http://<SERVER_IP>:8096` |
| **Jellyseerr**   | Content Requests   | 5055 | `http://<SERVER_IP>:5055` |
| **Sonarr**       | TV Show Management | 8989 | `http://<SERVER_IP>:8989` |
| **Radarr**       | Movie Management   | 7878 | `http://<SERVER_IP>:7878` |
| **qBittorrent**  | Torrent Client     | 8080 | `http://<SERVER_IP>:8080` |
| **Prowlarr**     | Indexer Management | 9696 | `http://<SERVER_IP>:9696` |
| **FlareSolverr** | Proxy Service      | 8191 | `http://<SERVER_IP>:8191` |

## ⏰ Automated Monitoring

### Setup Cron Jobs

Monitor Cloudflare WARP and indexer health every 15 minutes:

1. **Create Scripts Directory**

   ```bash
   mkdir -p scripts
   ```

2. **Copy Monitoring Scripts**
   Copy `check_warp.sh` and `check_indexers.sh` to the `scripts/` directory.

3. **Make Scripts Executable**

   ```bash
   chmod +x scripts/*.sh
   ```

4. **Configure Cron Jobs**

   ```bash
   crontab -e
   ```

   Add the following lines:

   ```cron
   */15 * * * * /path/to/media-server/scripts/check_warp.sh
   */15 * * * * /path/to/media-server/scripts/check_indexers.sh
   ```

5. **View Logs**
   ```bash
   cat $LOG_PATH/warp_check.log
   cat $LOG_PATH/indexer_check.log
   ```

## ⚙️ Configuration

### Homepage Customization

- **Services**: Edit `homepage/config/services.yaml` for API keys and credentials
- **Settings**: Customize `homepage/config/settings.yaml` for layout and theme
- **Widgets**: Modify `homepage/config/widgets.yaml` for system widgets

### Permissions Setup

```bash
sudo chown -R $PUID:$PGID homepage scripts logs
sudo chmod -R 755 homepage scripts logs
```

## 🔧 Troubleshooting

### Common Issues

#### Check Service Logs

```bash
docker logs <service-name>
```

#### Verify Docker Socket

```bash
ls -l /var/run/docker.sock
```

#### Confirm User Permissions

```bash
id
```

#### Test API Connectivity

```bash
curl -H "X-Api-Key: YOUR_SONARR_API_KEY" http://<SERVER_IP>:8989/api/v3/system/status
```

#### Check WARP Status

```bash
warp-cli status
```

## 📝 Important Notes

- **Security**: Services are configured for local-only access, making them safe for home networks
- **GitHub**: Replace `yourusername` in the clone command with your actual GitHub username
- **Optional**: Configure Cloudflare WARP for secure indexer traffic routing

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to improve this media server setup!
