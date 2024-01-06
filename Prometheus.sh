#!/bin/bash
# Update the system
#sudo apt-get update
sleep 1
# Create a user for prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
# Create some directories for prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
# change the ownership of the directories to prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
# Download the prometheus binary
wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz
sleep 10
# Extract the binary
tar xvf prometheus-2.48.1.linux-amd64.tar.gz
sleep 2
# Move the binary to /usr/local/bin
sudo cp prometheus-2.48.1.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.48.1.linux-amd64/promtool /usr/local/bin/
sleep 2
# change the ownership of the binary to prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
# move the consoles and console_libraries to /etc/prometheus/
sudo cp -r prometheus-2.48.1.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.48.1.linux-amd64/console_libraries /etc/prometheus
# change the ownership of the consoles and console_libraries to prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sleep 5
# remove the tar file and the extracted directory
rm -rf prometheus-2.48.1.linux-amd64.tar.gz prometheus-2.48.1.linux-amd64
# Create a configuration file for prometheus
sudo touch /etc/prometheus/prometheus.yml

echo "global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']" | sudo tee /etc/prometheus/prometheus.yml
cd
# change the ownership of the configuration file to prometheus
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
sleep 2
# Create a systemd service file for prometheus
sudo touch /etc/systemd/system/prometheus.service
echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service
sleep 2
# reload the systemd daemon and start the prometheus service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
exit
