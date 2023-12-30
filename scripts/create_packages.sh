#!/bin/bash

REPOSITORY_ARCH="${1}"

git config --global --add safe.directory /workspace/void-packages

cd /workspace/void-packages
ln -s / masterdir

# Allow nonfree software
echo XBPS_ALLOW_RESTRICTED=yes >> /workspace/void-packages/etc/conf

for xbps_pkg in $(ls -1 /workspace/packages); do
    xbps_pkg_binary_checksum=$(cat /workspace/packages/${xbps_pkg}/checksums/${REPOSITORY_ARCH}.txt)
    # xbps_pkg_license_checksum=$(cat /workspace/packages/${xbps_pkg}/checksums/license.txt)

    sed -i "s/%XDEB_INSTALL_BINARY_ARCH%/${REPOSITORY_ARCH}/" srcpkgs/${xbps_pkg}/template
    sed -i "s/%XDEB_INSTALL_BINARY_SHA256%/${xbps_pkg_binary_checksum}/" srcpkgs/${xbps_pkg}/template
    # sed -i "s/%XDEB_INSTALL_LICENSE_SHA256%/${xbps_pkg_license_checksum}/" srcpkgs/${xbps_pkg}/template

    # xlint ${xbps_pkg} || exit 1
    ./xbps-src pkg ${xbps_pkg} || exit 1
done

for xbps_pkg in $(cat /workspace/package-list); do
    ./xbps-src pkg ${xbps_pkg} || exit 1
done

# Hyprland's shlibs
cat /workspace/hyprland-void/common/shlibs >> /workspace/void-packages/common/shlibs
mv /workspace/hyprland-void/srcpkgs/* /workspace/void-packages/srcpkgs/
./xbps-src pkg hyprland || exit 1
./xbps-src pkg hyprpaper || exit 1
./xbps-src pkg xdg-desktop-portal-hyprland || exit 1

# Eww
mv /workspace/eww-void/srcpkgs/* /workspace/void-packages/srcpkgs/
./xbps-src pkg eww || exit 1
