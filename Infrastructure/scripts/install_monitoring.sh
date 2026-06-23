#!/bin/bash
exec > /var/log/install_monitoring.log 2>&1
set -euxo pipefail

yum update -y

# Install basic utilities
yum install -y wget tar firewalld

# Create monitoring user if it does not exist
if ! id prometheus >/dev/null 2>&1; then
  useradd --no-create-home --shell /bin/false prometheus
fi

# Download Prometheus
cd /tmp
wget -q https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz
tar xvf prometheus-2.54.1.linux-amd64.tar.gz

# Copy binaries
cp prometheus-2.54.1.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.54.1.linux-amd64/promtool /usr/local/bin/

# Create directories
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus

# Copy console files
cp -r prometheus-2.54.1.linux-amd64/consoles /etc/prometheus/
cp -r prometheus-2.54.1.linux-amd64/console_libraries /etc/prometheus/

# Set ownership
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
chown -R prometheus:prometheus /etc/prometheus
chown -R prometheus:prometheus /var/lib/prometheus

# Prometheus config
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create Prometheus systemd service
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Start Prometheus
systemctl daemon-reload
systemctl enable prometheus
systemctl restart prometheus

# Install Grafana
cat <<EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
enabled=1
gpgcheck=0
repo_gpgcheck=0
sslverify=1
EOF

yum clean all
yum makecache -y
yum install -y grafana

# Start Grafana
systemctl daemon-reload
systemctl enable grafana-server
systemctl restart grafana-server

# Final health checks
systemctl status prometheus --no-pager
systemctl status grafana-server --no-pager
curl -I http://localhost:9090 || true
curl -I http://localhost:3000 || true