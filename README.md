# site-cli

Simple CLI tool to manage Nginx sites without UI panel.

## Features
- Create sites via terminal
- Laravel / WordPress / PHP support
- Automatic SSL with Let's Encrypt (Certbot)
- No control panel, no UI
- Opinionated & production-oriented

## Requirements
- Ubuntu 20.04 / 22.04
- Nginx
- PHP-FPM
- Certbot

## Installation
```bash
git clone https://github.com/ardiwirawan/site-cli.git
cd site-cli
sudo ln -s $(pwd)/site /usr/local/bin/site

## Usage
sudo site
