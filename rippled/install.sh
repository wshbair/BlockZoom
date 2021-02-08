#install rippled server 

sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates wget gnupg
wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" | \
  sudo apt-key add -
echo "deb https://repos.ripple.com/repos/rippled-deb focal stable" | \
    sudo tee -a /etc/apt/sources.list.d/ripple.list
sudo apt -y update    
sudo apt -y install rippled
systemctl status rippled.service  
