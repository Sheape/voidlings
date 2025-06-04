[![Deployment Status](https://github.com/Sheape/voidlings/actions/workflows/build-x86_64-glibc.yml/badge.svg)](https://github.com/Sheape/voidlings/actions/workflows/build-x86_64-glibc.yml)

# Voidlings

This project represents my own custom Void Linux repository. Big thanks to [@xdeb-org](https://github.com/xdeb-org/voidlinux-repository) for the architecture. It contains various XBPS packages for x86_64 architecture which didn't make the merge into the official [void-linux/void-packages](https://github.com/void-linux/void-packages) repository for one reason or another.

## Available Packages
- Anki Qt 6
- Bat extras
- Brave Browser (binary)
- Bun (binary)
- Discord
- Cartograph Font (non-free)
- Comfortaa Font
- Lexend Font
- Quicksand Font
- Microsoft Core Fonts
- Neovide
- Qutebrowser Profile
- Zoom


The entire repository is managed via GitHub Actions (see [`.github/workflows`](.github/workflows)). The only thing hidden from the public is my private RSA key which is used to sign the XBPS package repository. Note that the packages are uploaded to [CloudFlare R2](https://developers.cloudflare.com/r2/) which you can sign up for free 10GB of blob storage.

## How to install

In order to install packages from this repository, create a new `.conf` file in the `/etc/xbps.d` directory containing the repository URL:
```
# /etc/xbps.d/99-voidlings.conf

repository=https://voidlings.paulgeraldpare.workers.dev
```

Then, synchronize the XBPS repositories:
```
$ sudo xbps-install -S
```

XBPS will ask you to import my RSA key. **Double check** the correctness of the key:
```
`https://voidlings.paulgeraldpare.workers.dev' repository has been RSA signed by "voidlings-github-action"
Fingerprint: 67:d2:bc:e0:4e:44:21:33:9e:9b:fe:35:d7:40:fd:09
```

After importing the key, you can execute `xbps-install <package>` to install any of the packages available for your host architecture at https://xdeb-org.github.io/voidlinux-repository.

