# Counter-Strike 2 Server on AWS São Paulo

This project sets up a Counter-Strike 2 dedicated server using Docker on AWS EC2 in the São Paulo region (sa-east-1).

## Prerequisites

- AWS Account
- Steam Account
- Steam Game Server Login Token (GSLT)

## Step 1: Get Your Steam GSLT Token

1. Go to [Steam Game Server Account Management](https://steamcommunity.com/dev/managegameservers)
2. Log in with your Steam account
3. Click "Create New Game Server Account"
4. App ID: `730` (Counter-Strike 2)
5. Memo: Something to identify your server (e.g., "CS2 AWS São Paulo")
6. Copy the generated token - you'll need this later

## Step 2: Launch an AWS EC2 Instance in São Paulo

### Instance Specifications

**Recommended Instance Type:** `t3.xlarge` or `c5.xlarge`
- **vCPUs:** 4+
- **RAM:** 8GB+ (16GB recommended for 32 players)
- **Storage:** 50GB+ SSD

### Launch Steps

1. **Sign in to AWS Console** and navigate to EC2
2. **Select Region:** São Paulo (sa-east-1)
3. **Launch Instance:**
   - **Name:** cs2-server-saopaulo
   - **AMI:** Ubuntu 22.04 LTS (64-bit x86)
   - **Instance Type:** t3.xlarge (or c5.xlarge for better performance)
   - **Key Pair:** Create new or use existing SSH key pair
   - **Network Settings:**
     - Create new security group or select existing
     - **Security Group Rules (CRITICAL):**
       ```
       SSH         TCP  22      Your IP (or 0.0.0.0/0)
       CS2 Game    TCP  27015   0.0.0.0/0
       CS2 Game    UDP  27015   0.0.0.0/0
       CS2 SourceTV UDP 27020   0.0.0.0/0 (if using SourceTV)
       ```
   - **Storage:** 50GB gp3 SSD (adjust based on needs)
4. **Launch** the instance

## Step 3: Connect to Your EC2 Instance

```bash
ssh -i your-key.pem ubuntu@<your-ec2-public-ip>
```

## Step 4: Install Docker and Docker Compose

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add your user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker-compose --version

# Log out and back in for group changes to take effect
exit
```

Then SSH back into your server.

## Step 5: Set Up CS2 Server Files

```bash
# Create directory for CS2 server
mkdir -p ~/cs2-server
cd ~/cs2-server

# Clone this repository or create files manually
# If you have this repo, clone it:
# git clone <your-repo-url> .

# Or create files manually (see below)
```

## Step 6: Configure Your Server

1. **Copy the environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file:**
   ```bash
   nano .env
   ```

3. **Set your configuration:**
   - `SRCDS_TOKEN`: Your Steam GSLT token from Step 1
   - `CS2_SERVERNAME`: Your server name (e.g., "CS2 São Paulo - Competitive")
   - `CS2_RCONPW`: Set a secure RCON password
   - `CS2_PW`: Set a server password (optional, leave empty for public)
   - Adjust other settings as needed

4. **Save and exit** (Ctrl+X, then Y, then Enter)

## Step 7: Start the Server

```bash
# Make the management script executable
chmod +x manage-server.sh

# Start the server
./manage-server.sh start

# Or use docker-compose directly
docker-compose up -d
```

## Step 8: Monitor the Server

```bash
# View server logs
./manage-server.sh logs

# Or
docker-compose logs -f cs2

# Check server status
./manage-server.sh status
```

The server will take 5-15 minutes to download and install CS2 on first launch.

## Step 9: Install Quake Sounds Plugin (Optional)

Add classic Quake sound effects to your CS2 server for kills, headshots, and more!

```bash
# Run the plugin installation script
./install-plugins.sh

# Restart the server to apply changes
./manage-server.sh restart
```

This installs:
- **CounterStrikeSharp** (CSS) - Required plugin framework
- **Quake Sounds Plugin** - Adds Quake-style sound effects

### Quake Sounds Features:
- 🎯 Kill sounds (Impressive, Excellent, Unstoppable, etc.)
- 💀 Headshot-specific sounds
- 🔪 Knife kill sounds (Humiliation!)
- 🩸 First blood announcement
- ⚔️ Multi-kill streak sounds
- 🏆 Round start/end sounds

### Customize Sounds:

Edit the configuration file:
```bash
nano addons/counterstrikesharp/configs/plugins/QuakeSounds/QuakeSounds.json
```

Enable/disable sounds and adjust volumes:
```json
{
  "KillSound": true,
  "HeadshotKillSound": true,
  "KnifeKillSound": true,
  "FirstKillSound": true,
  "KillSoundVolume": 0.5,
  "HeadshotKillSoundVolume": 0.5
}
```

After editing, restart: `./manage-server.sh restart`

## Server Management Commands

```bash
# Start server
./manage-server.sh start

# Stop server
./manage-server.sh stop

# Restart server
./manage-server.sh restart

# View logs
./manage-server.sh logs

# Check status
./manage-server.sh status

# Update server
./manage-server.sh update
```

## Connecting to Your Server

1. **Get your EC2 public IP** from AWS Console
2. **In CS2:**
   - Open console (`) 
   - Type: `connect <your-ec2-ip>:27015`
   - Or find it in the Community Server Browser

## RCON Administration

You can use RCON to manage your server remotely:

```bash
# Using RCON CLI (in a separate terminal)
docker exec -it cs2-server rcon_address localhost:27015
docker exec -it cs2-server rcon_password <your-rcon-password>
```

Or use an RCON tool like:
- [SourceAdminTool](https://sourceadmintool.com/)
- [CS2 RCON](https://github.com/fpaezf/CS2-RCON-Tool-V2)

## Troubleshooting

### Server won't start
- Check if ports are open in AWS Security Group
- Verify GSLT token is valid
- Check logs: `docker-compose logs cs2`

### Can't connect to server
- Verify EC2 security group has ports 27015 (TCP/UDP) open
- Check if server is running: `docker ps`
- Verify your EC2 instance has a public IP
- Try connecting via console: `connect <ip>:27015`

### Server crashes or restarts
- Check available memory: `free -h`
- Consider upgrading instance type
- Check logs for errors: `docker-compose logs cs2`

### Poor performance
- Upgrade to c5.xlarge or larger instance
- Enable gp3 SSD with higher IOPS
- Check network latency

### Plugins not working
- Ensure you ran `./install-plugins.sh`
- Check that the server restarted after plugin installation
- Verify files exist in `addons/counterstrikesharp/plugins/`
- Check logs: `docker-compose logs cs2 | grep -i "counterstrike"`

## Cost Estimation (São Paulo Region)

- **t3.xlarge:** ~$0.1664/hour (~$120/month)
- **c5.xlarge:** ~$0.192/hour (~$140/month)
- **Storage (50GB gp3):** ~$4/month
- **Data Transfer:** Varies by usage (~$0.15/GB out)

**Monthly estimate:** $130-$160 USD

## Optimization Tips

1. **Use Spot Instances** for up to 70% cost savings (risk of interruption)
2. **Stop instance when not in use** (only pay for storage)
3. **Use Elastic IP** to keep same IP when stopping/starting
4. **Enable CloudWatch monitoring** for performance insights
5. **Set up auto-backup** using AWS Backup or snapshots

## Map Configuration

Common maps:
- `de_dust2`
- `de_inferno`
- `de_mirage`
- `de_nuke`
- `de_overpass`
- `de_vertigo`
- `de_ancient`
- `de_anubis`

Edit `CS2_STARTMAP` in `.env` to change the starting map.

## Additional Resources

- [joedwards32/CS2 Docker Image](https://github.com/joedwards32/CS2)
- [CounterStrikeSharp](https://github.com/roflmuffin/CounterStrikeSharp) - Plugin framework
- [Quake Sounds Plugin](https://github.com/NockyCZ/CS2-QuakeSounds)
- [CS2 Server Commands](https://developer.valvesoftware.com/wiki/List_of_CS2_console_commands_and_variables)
- [AWS EC2 Pricing](https://aws.amazon.com/ec2/pricing/)

## Security Recommendations

1. Change default RCON password
2. Keep your SSH key secure
3. Limit SSH access to your IP
4. Regularly update the server: `docker-compose pull && docker-compose up -d`
5. Enable AWS CloudTrail for audit logging
6. Consider using AWS Systems Manager for secure access

## License

This configuration is provided as-is for educational and personal use.

## Support

For issues with:
- **Docker image:** [joedwards32/CS2 GitHub Issues](https://github.com/joedwards32/CS2/issues)
- **CS2 Server:** [Steam Community](https://steamcommunity.com/app/730/discussions/)
- **AWS:** [AWS Support](https://aws.amazon.com/support/)
