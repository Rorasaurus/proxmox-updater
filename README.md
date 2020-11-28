# proxmox-updater
Updater for Proxmox 6.* no subscription

## Purpose
This script will configure Proxmox to allow it to update from the pve-no-subscription source.

This script only supports Proxmox 6.*

## Usage
proxmox-update.sh {optional_argument}

Optional arguments:

* disable-enterprise-src     ### Disable Enterprise package source
* make-free-source           ### Create free package source file
* update-only                ### Run the update process only
* backup-enterprise          ### Backup the Enterprise source file
* restore-enterprise         ### Restore the Enterprise source file

Executing without optional arguments will configure the source files, create backups and update the packages