# arch
startx

### ARCH iso 2022-08-05
do not run pacstrap or pacman before pacman-init.service has finished

```systemctl status -l pacman-init.service```

## WIFI
### iwctl 
```station wlan0 scan```

```station wlan0 get-networks```

```station wlan0 connect [SSI]```

### networkmanager
```nmcli device wifi list```

```nmcli device wifi connect [SSID or BSSID] password [password]```

### TMUX
```Alt + b + I```

### NVIM
```:PlugInstall```

```:CocInstall coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp coc-texlab```
