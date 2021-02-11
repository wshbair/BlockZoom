#install rippled server 

sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates wget gnupg
wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" | \
  sudo apt-key add -
echo "deb https://repos.ripple.com/repos/rippled-deb focal stable" | \
    sudo tee -a /etc/apt/sources.list.d/ripple.list
sudo apt -y update    
sudo apt -y install rippled
systemctl is-active rippled.service

sudo apt-get install collectd -y
sudo apt install python-pip -y

sudo apt-get install g++ curl libssl-dev -y
sudo apt-get install git-core -y

# Install Nodejs
sudo apt-get install python-software-properties python make -y
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs -y

# Clone the statsd project 
git clone https://github.com/etsy/statsd.git
cd ./statsd

# Create a config file for statsd
cp ./statsd/exampleConfig.js ./statsd/config.js
$EDITOR ./statsd/config.js

# Install foreman so we can run our process though and Procfile and easily export to Upstart
sudo gem install foreman
# echo -e "\nexport PATH=/usr/local/bin:~/bin:$PATH\n" >> ~/.bashrc && source ~/.bashrc
# Shoreman would be another option, but doesn't have an export command
# mkdir ~/bin && curl https://github.com/hecticjeff/shoreman/raw/master/shoreman.sh -sLo ~/bin/shoreman && chmod 755 ~/bin/shoreman

# Create .env and Procfile
echo "statsd: node ./statsd/stats.js ./statsd/config.js" >> Procfile
touch .env

# Export to upstart
sudo foreman export upstart /etc/init -a statsd -u $USER

# Start the process 
sudo start statsd

# Stop the process when necessary
#sudo stop stat
sudo apt install npm
