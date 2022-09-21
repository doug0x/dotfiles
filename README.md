# arch

### ARCH iso 2022-08-05
do not run pacstrap or pacman before pacman-init.service has finished

```systemctl status -l pacman-init.service```

### WIFI

```nmcli device wifi list```

```nmcli device wifi connect [SSID or BSSID] password [password]```

### TMUX
After all:

```Alt + b + I```

### NVIM
After all:

```:PlugInstall```

```:CocInstall coc-tsserver coc-java coc-json coc-pyright coc-sh coc-html coc-css coc-snippets coc-vimlsp coc-texlab```
