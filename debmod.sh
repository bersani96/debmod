#!/bin/bash

#  Script creato da TheZero
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
 

build(){
	cd "$ARCHIVE_FULLPATH"
    find . -type f ! -regex '.*\.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
    cd ..
    dpkg-deb -b "$ARCHIVE_FULLPATH"
    read -p "Eliminare i file sorgenti? (Y/N)" $OPTION
    if [ "$OPTION" == "Y" ]; then
		rm -fv -R "$ARCHIVE_FULLPATH"
    fi
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Lavoro finito, Padrone" "Pacchetto Creato con successo <b>$FILENAME</b>"

}


extract(){
	
	mkdir "$NEWDIRNAME"
    cp -fv -R "$ARCHIVE_FULLPATH" "$NEWDIRNAME"
    cd "$NEWDIRNAME"
    ar vx "$FILENAME"
    rm -fv -R "$FILENAME"
    for FILE in *.tar.gz; do [[ -e $FILE ]] && tar xvpf $FILE; done
    for FILE in *.tar.lzma; do [[ -e $FILE ]] && tar xvpf $FILE; done
    [[ -e "control.tar.gz" ]] && rm -fv -R "control.tar.gz"
    [[ -e "data.tar.gz" ]] && rm -fv -R "data.tar.gz"
    [[ -e "data.tar.lzma" ]] && rm -fv -R "data.tar.lzma"
    [[ -e "debian-binary" ]] && rm -fv -R "debian-binary"

    mkdir "DEBIAN"
    [[ -e "changelog" ]] && mv -fv "changelog" "DEBIAN"
    [[ -e "config" ]] && mv -fv "config" "DEBIAN"
    [[ -e "conffiles" ]] && mv -fv "conffiles" "DEBIAN"
    [[ -e "control" ]] && mv -fv "control" "DEBIAN"
    [[ -e "copyright" ]] && mv -fv "copyright" "DEBIAN"
    [[ -e "postinst" ]] && mv -fv "postinst" "DEBIAN"
    [[ -e "preinst" ]] && mv -fv "preinst" "DEBIAN"
    [[ -e "prerm" ]] && mv -fv "prerm" "DEBIAN"
    [[ -e "postrm" ]] && mv -fv "postrm" "DEBIAN"
    [[ -e "rules" ]] && mv -fv "rules" "DEBIAN"
    [[ -e "shlibs" ]] && mv -fv "shlibs" "DEBIAN"
    [[ -e "templates" ]] && mv -fv "templates" "DEBIAN"
    [[ -e "triggers" ]] && mv -fv "triggers" "DEBIAN"
    [[ -e ".svn" ]] && mv -fv ".svn" "DEBIAN"

    [[ -e "md5sums" ]] && rm -fv -R "md5sums"
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Lavoro finito, Padrone" "Pacchetto Estratto con successo"
		
}


# Program Main #

case $1 in
"b")
	if [ $2 >/dev/null ]; then
		ARCHIVE_FULLPATH="$2"
		NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
	else
		echo "Genio, Dammi un file da aprire se no non servo a niente!"
		exit 1
	fi
	build
;;
"x")
	if [ $2 >/dev/null ]; then
		ARCHIVE_FULLPATH="$2"
		NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
		FILENAME=${ARCHIVE_FULLPATH##*/}
	else
		echo "Genio, Dammi un file da aprire se no non servo a niente!"
		exit 1
	fi
	extract
;;
*)
	echo -e "Che cazzo stai facendo?! Non puoi guidare se sei ubriaco! \n\n$0 b \"cartella-sorgenti\" - per creare un deb\n$0 x \"nome.deb\" - per estrarre il contenuto di un deb\n"
;;
esac

exit 0
