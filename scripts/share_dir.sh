#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "❌ Usage: $0 <target_directory> <share_with_user_or_group>"
    echo "💡 Example: $0 /var/www www-data"
    exit 1
fi

TARGET_DIR="$1"
SHARE_USER="$2"

# Detect the real user accurately whether running with or without sudo prefix
if [ -n "$SUDO_USER" ]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER=$(whoami)
fi

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist!"
    exit 1
fi

echo "=============================================="
echo "🚀 Starting Permission Configuration..."
echo "📂 Target Directory: $TARGET_DIR"
echo "👤 Real User:       $REAL_USER (Will retain read/write access)"
echo "👥 Shared Target:   $SHARE_USER (Will grant read/write access)"
echo "=============================================="

# 1. Add the real user to the target group (Requires sudo)
if ! groups "$REAL_USER" | grep -qw "$SHARE_USER"; then
    echo "🔄 Adding user '$REAL_USER' to group '$SHARE_USER'..."
    sudo usermod -aG "$SHARE_USER" "$REAL_USER"
    echo "💡 Notice: Group membership updated. You may need to restart your terminal session."
fi

# 2. Change base ownership (Requires sudo)
echo "📦 Changing directory ownership..."
sudo chown -R "$REAL_USER":"$SHARE_USER" "$TARGET_DIR"

# 3. Set standard permissions (Requires sudo)
echo "🔒 Setting base directory permissions (775)..."
sudo chmod -R 775 "$TARGET_DIR"

# 4. Enable SGID for group inheritance (Requires sudo)
echo "🧬 Enabling SGID for group inheritance..."
sudo find "$TARGET_DIR" -type d -exec chmod g+s {} +

# 5. Configure ACL rules (Requires sudo)
echo "🛠️ Configuring ACL dynamic rules..."
if ! command -v setfacl &> /dev/null; then
    echo "📦 Installing acl package..."
    sudo apt-get update && sudo apt-get install -y acl
fi

# Clear existing ACLs for a clean state
sudo setfacl -R -b "$TARGET_DIR"

# Apply ACL permissions to current existing files and directories
sudo find "$TARGET_DIR" -exec setfacl -m u:"$REAL_USER":rwx,g:"$SHARE_USER":rwx {} +

# Set default ACLs for future files/directories under each directory
sudo find "$TARGET_DIR" -type d -exec setfacl -d -m u:"$REAL_USER":rwx,g:"$SHARE_USER":rwx {} +

echo "=============================================="
echo "    ✨ Permissions Configured Successfully!"
echo "    Any files created inside $TARGET_DIR by either"
echo "    party will automatically grant full R/W access."
echo "=============================================="

