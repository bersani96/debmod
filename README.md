debmod
======

A simple bash script to manage deb package. To use this script you need to have installed on yout computer the package "zenity".
With this script you can:
* extract deb file
* build deb file
* install deb file

To execute this script in the right way tou need tu execute it as root.

#Installation
To install debmod you have two possibilities:
*Download from GitHub
You can downlaod the source code from github and use it manually.
```sh
wget https://github.com/bersani96/debmod/archive/GUI.zip
unzip GUI.zip
cd debmod-GUI
./debmod.sh
```
*Downlaod deb package
Or you can download the deb package and install it.
```sh
wget https://github.com/bersani96/debmod/blob/GUI/debmod.deb
dpkg -i debmod.deb
```
It will create also a starter in the menù.
