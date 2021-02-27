#install rippled server 

sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates wget gnupg
wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" | \
  sudo apt-key add -
echo "deb https://repos.ripple.com/repos/rippled-deb focal stable" | \
    sudo tee -a /etc/apt/sources.list.d/ripple.list
sudo apt -y update --allow-unauthenticated --allow-insecure-repositories

#Install Rippled 1.6.0 
sudo apt-get install rippled=1.6.0-1

#Install Rippled 1.7.0 
#sudo apt-get install rippled

#sudo apt -y install rippled --allow-unauthenticated
sudo systemctl stop rippled.service
#systemctl is-active rippled.service

sudo apt-get install collectd -y --allow-unauthenticated
sudo apt install python-pip -y --allow-unauthenticated

sudo apt-get install g++ curl libssl-dev -y --allow-unauthenticated
sudo apt-get install git-core -y --allow-unauthenticated

# Install yarn
sudo apt install cmdtest -y --allow-unauthenticated

# Install Nodejs
sudo apt-get install python-software-properties python make -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs --allow-unauthenticated
sudo apt install npm -y --allow-unauthenticated

# Install ripple-lib
npm i ripple-lib

sudo git clone https://github.com/etsy/statsd.git /opt/statsd
