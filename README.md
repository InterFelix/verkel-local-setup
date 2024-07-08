# Verkel local network setup

This repo contains everything necessary to install an instance of verkel for use in a local network environment.
There is no built-in support for external SSL certificates, although it's trivial to supply your own by using certbot and pointing it to the "nginx/certs" subdirectory.

## How to install verkel

1. Make sure you have installed all necessary packages:
   - git
   - docker
   - docker-compose-plugin
   - pwgen

2. Clone this repository:

   ```bash
   git clone git@git.vcp-dev.de:vcp-sh/ak-internet/verkel-compose.git /etc/verkel
   ```

3. Run the script:

   ```bash
   # Switch to verkel directory:
   cd /etc/verkel
   # Make the install-script executable:
   chmod +x install.sh
   # Run the install-script:
   ./install.sh
   ```