# If NixOS is already installed abort script
# Check if NixOS is installed by verifying the absence of a typical live environment directory
if [ ! -d "/mnt/etc/nixos" ] && [ -d "/etc/nixos" ]; then
  echo "NixOS is already installed. Aborting."
  exit 1
fi

##################################################
## DANGER ZONE THIS SECTION WILL NUKE ALL DISKS ##
##################################################
# wipefs -a /dev/nvme0n1
# wipefs -a /dev/nvme1n1
# wipefs -a /dev/nvme2n1
# wipefs -a /dev/nvme3n1
# wipefs -a /dev/nvme4n1
# zpool labelclear -f /dev/nvme0n1§
# zpool labelclear -f /dev/nvme1n1
# zpool labelclear -f /dev/nvme2n1
# zpool labelclear -f /dev/nvme3n1
# zpool labelclear -f /dev/nvme4n1

########## Create the file system ##########

# Serial numbers of the disks
serial_numbers=(
  "S69ENF0WB69369T" # MB 1 (from cpu)
  "S69ENF0WB69363F" # MB 2
  "S69ENF0WB69149W" # MB 3
  "S69ENF0WB69358N" # Hyper card 
  "S69ENF0WB69366M" # Ice card
)

# Identify the disk for the ESP (EFI System Partition)
esp_serial_number="S69ENF0WB69369T"
esp_device_link=$(ls -l /dev/disk/by-id/*${esp_serial_number}* | grep -v "part" | head -n 1 | awk '{print $9}')
ESP_PARTITION=$(readlink -f $esp_device_link)
echo "ESP disk: $ESP_PARTITION"

# Partition the disk
parted $ESP_PARTITION --script -- mklabel gpt
parted $ESP_PARTITION --script -- mkpart ESP fat32 1MiB 512MiB
parted $ESP_PARTITION --script -- set 1 esp on
parted $ESP_PARTITION --script -- mkpart primary 512MiB 100%

# Identify the disks for the raidz2 pool
raidz2_disks=()
for serial_number in "${serial_numbers[@]}"; do
  device_link=$(ls -l /dev/disk/by-id/*${serial_number}* | grep -v "part" | head -n 1 | awk '{print $9}')
  disk=$(readlink -f $device_link)
  # Use only partition 2 if it's the ESP disk
  if [ "$serial_number" == "$esp_serial_number" ]; then
    raidz2_disks+=("${disk}p2")
  else
    raidz2_disks+=("$disk")
  fi
done
echo "Raidz2 disks: ${raidz2_disks[@]}"

# Create the raidz2 pool
zpool create -f -O encryption=on -O keyformat=passphrase -O keylocation=prompt -O compression=zstd -O mountpoint=none -O xattr=sa -O acltype=posixacl -o ashift=12 zpool raidz2 "${raidz2_disks[@]}"

# Create ZFS datasets for system use
zfs create -o mountpoint=legacy zpool/root
zfs create -o mountpoint=legacy zpool/nix
zfs create -o mountpoint=legacy zpool/var
zfs create -o mountpoint=legacy zpool/home
# Create datasets specifically for your user data
zfs create -o mountpoint=legacy zpool/home/data
zfs create -o mountpoint=legacy zpool/home/github
zfs create -o mountpoint=legacy zpool/home/clickhouse
# Set specific ZFS properties based on data characteristics
zfs set compression=off zpool/home/clickhouse  # No compression for ClickHouse

mkdir /mnt/root
mount -t zfs zpool/root /mnt

mkdir /mnt/nix /mnt/var /mnt/home
mount -t zfs zpool/nix /mnt/nix
mount -t zfs zpool/var /mnt/var
mount -t zfs zpool/home /mnt/home

# Setup and mount the EFI System Partition (boot)
mkfs.fat -F 32 -n BOOT ${ESP_PARTITION}p1
mkdir -p /mnt/boot
mount -o umask=077 ${ESP_PARTITION}p1 /mnt/boot

####### Configure for installation ##########
# NixOS, User, ZFS, Git, Region.
nixos-generate-config --root /mnt
cp dotfiles/oak/oak-install.nix /mnt/etc/nixos/configuration.nix
cp dotfiles/oak/oak-filesystems.nix /mnt/etc/nixos/


########## Get or Create Hashed Password ##########

# Prompt for the password
read -s -p "Enter the initial password: " password
echo
read -s -p "Confirm the password: " password_confirm
echo

# Check if the passwords match
if [ "$password" != "$password_confirm" ]; then
  echo "Passwords do not match. Please try again."
  exit 1
fi

# Generate the hashed password
hashedPassword=$(nix-shell -p mkpasswd --run 'mkpasswd -m sha-512 <<< "$password"')

######### Get parameters for configuration.nix #########
# Identify the boot partition and set networking host id for ZFS
ESP_UUID=$(blkid -s UUID -o value ${ESP_PARTITION}p1) 
NETWORKING_HOST_ID=$(head -c 4 /dev/urandom | od -A none -t x8 | awk '{print substr($1,length($1)-7,8)}') # Configuration.nix need to give ZFS a unique Networking Host ID

########## Save the system parameters to a file ##########
cat <<EOF > /mnt/etc/nixos/systemParams.json
{
    "hashedPassword": "$hashedPassword",
    "networkingHostId": "$NETWORKING_HOST_ID",
    "espUUID": "$ESP_UUID"
}
EOF

########## Install NixOS. Woohoo! ##########
# nixos-install
# reboot

