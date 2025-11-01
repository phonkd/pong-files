# Pong Files

Docker Compose configuration files for various services running on a Termux/Android environment.

## Services

### doco-cd (Docker Compose Continuous Deployment)

A lightweight GitOps tool that automatically deploys and updates Docker Compose projects using polling.

#### Setup Instructions

1. **Create a GitHub Personal Access Token**
   
   To allow doco-cd to access this repository, you need to create a GitHub Personal Access Token:
   
   a. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
      - Direct link: https://github.com/settings/tokens
   
   b. Click "Generate new token" → "Generate new token (classic)"
   
   c. Configure the token:
      - **Note**: `doco-cd access for pong-files` (or any descriptive name)
      - **Expiration**: Choose an appropriate expiration (recommended: 90 days or custom)
      - **Scopes**: Select `repo` (Full control of private repositories)
        - This includes: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`
   
   d. Click "Generate token" and **copy the token immediately** (you won't be able to see it again)

2. **Configure the Token**
   
   Create a `.env` file in the repository root with your token:
   ```bash
   echo "GIT_ACCESS_TOKEN=ghp_your_token_here" > .env
   ```
   
   Or export it as an environment variable before starting doco-cd:
   ```bash
   export GIT_ACCESS_TOKEN=ghp_your_token_here
   ```

3. **Start doco-cd**
   ```bash
   docker compose -f doco-cd-compose.yaml up -d
   ```

4. **Verify it's working**
   - Check logs: `docker logs doco-cd`
   - Access health endpoint: `curl http://localhost:8080/v1/health`
   - View metrics: `curl http://localhost:9120/metrics`

#### What does doco-cd do?

- Polls this repository every 3 minutes for changes
- Automatically deploys stacks defined in `.doco-cd.yaml`
- Currently manages: `prometheus-and-mystrom-exporter` stack

### Prometheus + MyStrom Exporter

Prometheus monitoring setup with MyStrom device exporter.

**Stack location**: `stacks/prometheus-and-mystrom-exporter/`

**Services**:
- **Prometheus**: Metrics collection and storage (port 9090)
- **MyStrom Exporter**: Exports metrics from MyStrom devices (port 9452)

**Configuration**:
- Scrapes MyStrom device at `192.168.1.19` every 30 seconds
- Prometheus configuration: `prometheus.yml`

**Start the stack**:
```bash
cd stacks/prometheus-and-mystrom-exporter
docker compose up -d
```

Or let doco-cd manage it automatically!

### Dockge

Alternative Docker Compose management UI (if you prefer a web interface over doco-cd).

**Start Dockge**:
```bash
docker compose -f dockge-compose.yaml up -d
```

Access at: `http://localhost:5001`

## Network Configuration

The repository includes network routing scripts for Termux/Android environments:
- `network-routes.sh`: Configures container networking
- `boot-startup-scripts.sh`: Auto-start services on boot

## Directory Structure

```
.
├── doco-cd-compose.yaml              # doco-cd deployment
├── dockge-compose.yaml               # Dockge deployment (alternative)
├── .doco-cd.yaml                     # doco-cd configuration
├── prometheus.yml                    # Prometheus config (root)
├── stacks/
│   └── prometheus-and-mystrom-exporter/
│       ├── compose.yaml              # Stack compose file
│       ├── prometheus.yml            # Prometheus config (stack)
│       └── .env                      # Environment variables
├── boot-startup-scripts.sh           # Termux boot scripts
└── network-routes.sh                 # Network configuration
```

## Security Notes

- Never commit `.env` files or tokens to the repository
- The `.env` file is already in `.gitignore`
- Use environment variables or Docker secrets for sensitive data
- Regularly rotate GitHub access tokens
- Use the minimum required token scopes

## Troubleshooting

### doco-cd not deploying
1. Check logs: `docker logs doco-cd`
2. Verify token has correct permissions
3. Ensure `.doco-cd.yaml` syntax is correct
4. Check that the repository is accessible

### Prometheus not scraping
1. Verify MyStrom device is accessible: `curl http://192.168.1.19`
2. Check exporter logs: `docker logs mystrom-exporter`
3. Check Prometheus targets: http://localhost:9090/targets

## References

- [doco-cd Wiki](https://github.com/kimdre/doco-cd/wiki)
- [doco-cd Quickstart](https://github.com/kimdre/doco-cd/wiki/Quickstart)
- [Prometheus Documentation](https://prometheus.io/docs/)
