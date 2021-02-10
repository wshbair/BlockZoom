#!/bin/bash
# Generate validation key
/opt/ripple/bin/validator-keys create_keys

#Generate validation token
/opt/ripple/bin/validator-keys create_token --keyfile /root/.ripple/validator-keys.json >> /etc/opt/ripple/rippled.cfg
