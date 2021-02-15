#install rippled server 

sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates wget gnupg
wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" | \
  sudo apt-key add -
echo "deb https://repos.ripple.com/repos/rippled-deb focal stable" | \
    sudo tee -a /etc/apt/sources.list.d/ripple.list
sudo apt -y update --allow-unauthenticated --allow-insecure-repositories
sudo apt -y install rippled --allow-unauthenticated
systemctl is-active rippled.service

sudo apt-get install collectd -y
sudo apt install python-pip -y

sudo apt-get install g++ curl libssl-dev -y
sudo apt-get install git-core -y

# Install Nodejs
sudo apt-get install python-software-properties python make -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt install npm -y
npm i ripple-lib

sudo git clone https://github.com/etsy/statsd.git /opt/statsd
