# Install Ubuntu
1. Download ISO
1. Create USB Flash (using ??)
1. Fresh install Ubuntu
	1. Do not use ZFS
1. Install updates

# Configure System
```bash
sudo apt install gnome-tweaks vim
mkdir ~/bin
mkdir ~/Code
mkdir ~/Temp
```

## Update Files
```
sudo vim ~/.config/user-dirs.dirs
# comment out unused ones (desktop, music, pictures, videos)
sudo vim /etc/xdg/user-dirs.defaults
# do the same as above

xdg-user-dirs-update
```

## In `Settings`
### Appearance 
- Set "Style" to "Dark"
- Set "Color" to Green
- Set Dock to Auto-hide
- Set Panel mode to off

### Power
- Toggle on "Show battery percentage"

## In `Tweaks`: Top Bar
- Toggle all clock to on
- Toggle week numbers on

## In `Files`
- Delete `Videos`
- Create blank_text.txt in ~/Templates

