if [ $# != 3 ]; then
  echo "\nusage: setup.sh clash-version clash-config-link\n\ne.g.\n\n'setup.sh amd64 fuck.gfw.com/clash' will download clash from https://github.com/Dreamacro/clash/releases/download/v1.11.8/amd64.gz and use config file downloaded from fuck.gfw.com/clash\n"
  exit 1
fi


clash_version=$1
clash_config_link=$2

apt install -y fish

mkdir -p ~/.config/clash
curl "$clash_config_link" > ~/.config/clash/config.yaml

wget https://github.com/Dreamacro/clash/releases/download/v1.11.8/"$clash_version".gz

gunzip "$clash_version".gz
mkdir -p ~/.local/bin

mv "$clash_version" .local/bin/clash
chmod +x .local/bin/clash

echo "PATH=$PATH:~/.local/bin" >> ~/.bashrc
source "$HOME"/.bashrc
clash &

proxy_server=http://127.0.0.1:7890

echo "HTTPS_PROXY=$proxy_server
HTTP_PROXY=$proxy_server
NO_PROXY=10.0.0.0/8,192.168.0.0/16,127.0.0.1,172.16.0.0/16
https_proxy=$proxy_server
http_proxy=$proxy_server
no_proxy=10.0.0.0/8,192.168.0.0/16,127.0.0.1,172.16.0.0/16
" >> /etc/environment

source /etc/environment

snap install microk8s --classic

microk8s.start
microk8s.status -w


microk8s.disable ha-cluster --force
microk8s.enable dns
microk8s.enable metrics-server

exit 0
