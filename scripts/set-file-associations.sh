#!/usr/bin/env bash

# Create the MIME type definition for .nix files
mkdir -p ~/.local/share/mime/packages
cat > ~/.local/share/mime/packages/nixos-mime.xml <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="text/x-nix">
    <sub-class-of type="text/plain"/>
    <glob pattern="*.nix"/>
  </mime-type>
</mime-info>
EOT

# Update the MIME database
update-mime-database ~/.local/share/mime

# Verify the file creation
if [ -f ~/.local/share/mime/packages/nixos-mime.xml ]; then
    echo "MIME type definition created successfully."
else
    echo "Failed to create MIME type definition."
    exit 1
fi

# Create the desktop entry for Visual Studio Code
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/code.desktop <<EOT
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=code --no-sandbox --unity-launch %F
Icon=code
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;text/x-nix;
Actions=new-window;

[Desktop Action new-window]
Name=New Window
Exec=code --no-sandbox --new-window %F
Icon=code
EOT

# Update the desktop database
update-desktop-database ~/.local/share/applications

# Set the default application for .nix files
xdg-mime default code.desktop text/x-nix

echo "File association for .nix files set to Visual Studio Code."
