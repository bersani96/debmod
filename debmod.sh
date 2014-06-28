#!/bin/bash
# Script creato da TheZero
#
# Version GUI (Fork by Pinperepette)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#

# Funzioni #############################################################
menu_principale(){
	azione=`zenity --list \
	  --title="D E B M O D" \
	  --text="What should I do?" \
	  --column="Options :" \
	"I extract a deb file" \
	"I create a deb file" \
	"I install a deb file"`
}

extract(){

	(mkdir "$NEWDIRNAME"
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

	[[ -e "md5sums" ]] && rm -fv -R "md5sums") | zenity --progress --title="D E B M O D..." --text="deb extraction" --auto-kill --pulsate

}

#Create control file
file_control(){
        cd DEBIAN
        echo Package: $nome >>control
        dato=`zenity --entry --title="D E B M O D E" --text="Version of programm"`
        echo Version: $dato >>control
        echo Architecture: all >>control
        dato=`zenity --entry --title="D E B M O D E" --text="Name of the developer and email\nExample: Tizio Caio <tizio@provider.com>"`
        echo Maintainer: $dato >>control
        dato=`zenity --entry --title="D E B M O D E" --text="Dependencies"`
        echo Depends: $dato >>control
        echo Section: base >>control
        dato=`zenity --entry --title="D E B M O D E" --text="Homepage"`
        echo Homepage: $dato >>control
        dato=`zenity --entry --title="D E B M O D E" --text="Description"`
        echo Description: $dato >>control
        cd .. #go back to $nome (package's directory)
}

#Create .desktop file (starter for the menù)
file_desktop(){
        cd usr/share/applications
        echo "[Desktop Entry]" >>$nome.desktop
        echo "Encoding=UTF-8" >>$nome.desktop
        echo "Type=Application" >>$nome.desktop
        echo "Version=1.0" >>$nome.desktop
        echo "Name=$nome" >>$nome.desktop
        #Check if the user want to use a custom icon
        zenity --question --title="D E B M O D E" --text="Do you want to use a custom icon?\nIf no, a default icon will be used. The icon must be 48x48."
        if [ $? -eq 0 ]
        then
                #Create de directory for the icon
                cd .. #go to /usr/share
                mkdir -p icons/hicolor/48x48/
                cd applications #go back to /usr/share/applications
                #Choose the icon
                dato=`zenity --file-selection --title="Choose the icon"`
                #Copy the icon to the directory use for the icons
                cp $dato ../icons/hicolor/48x48/$nome.png
                echo "Icon=/usr/share/icons/hicolor/48x48/$nome.png" >>$nome.desktop
        else
                #Else, i use a random icon
                echo "Icon=~/icona/gnome-multimedia.png" >>$nome.desktop
        fi
        dato=`zenity --entry --title="D E B M O D E" --text="Command for start the programm"`
        echo "Exec=$dato" >>$nome.desktop
        zenity --question --title="D E B M O D E" --text="Does the programm start in a terminal?"
        if [ $? -eq 0 ]
        then
                echo "Terminal=true" >>$nome.dekstop
        else
                echo "Terminal=false" >>$nome.dekstop
        fi
        echo "Categories=Utility;Accessories;" >>$nome.desktop
        cd ../../.. #Go back to $nome
}

build(){
#Structure
        cd $nome #Move into the package's directory
        mkdir DEBIAN usr usr/bin
        #Tell to the user that he should put all executable files in a directory
        zenity --info --title="D E B M O D" --text="Now you are going to select a directory with all the executable files. If you don't have created it, you should do it now. Press ok when you are ready."
        #Choose the executable file
        dir=`zenity --file-selection --directory --title="Choose the directory with all executable files"`
        cp -r $dir usr/bin/
        #Create the control file of the package
        file_control
       
        #Check if the user want to create a .destop file
        zenity --question --title="D E B M O D E" --text="Do you want to create a starter for the menù?"
        if [ $? -eq 0 ]
        then
                mkdir -p usr/share/applications
                file_desktop
        fi
        
        #Create the package
        cd .. #Go out the package's directory
        (
        echo 20
        dpkg -b $nome
        echo 100
        )| zenity --progress --title="D E B M O D E" --text="Building package..." --auto-close --pulsate
        #Package created, send a notification
        if [ -e $nome.deb ]
        then
zenity --info --title="D E B M O D E" --text="Package successfully created"
#Delete the directory and other files
rm -rf $nome
else
zenity --error --title="D E B M O D E" --text"Package not created"
rm -rf $nome
fi
}

install_deb(){
        #Choose the package
        deb=`zenity --file-selection --title="Choose the package"`
        (
        echo 20
        #Install the package
        dpkg -i $deb
        if [ $? -eq 0 ]
        then
         zenity --info --title="D E B M O D E" --text="Package successfully installed"
        else
         zenity --error --title="D E B M O D E" --text"Package not installed"
        fi
        echo 100
        )| zenity --progress --title="D E B M O D E" --text="Installing package..." --auto-close --pulsate
}

# Script ###############################################################
#First, I control if zenity is installed
if ! type zenity >/dev/null
then
echo "It's impossible to execute the script. The package zenity is not installed."
exit 1
fi
menu_principale
case $azione in
"I extract a deb file")
	file=`zenity --file-selection --title="Select a File"`
	if [ $file >/dev/null ]; then
		ARCHIVE_FULLPATH="$file"
		NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
		FILENAME=${ARCHIVE_FULLPATH##*/}
	else
		zenity --error --no-wrap --no-markup --text="You have not selected folder" --title="D E B M O D ERROR" --window-icon='error' --width=400 --height=300
		exit 1
	fi
	extract
;;
"I create a deb file")
#Build e deb file
        #Name of package
        nome=`zenity --entry --title="D E B M O D" --text="Name of package"`
	if [ "$nome" = '' ]
	then
		zenity --error --no-wrap --no-markup --text="It's impossible to create the package. A name is necessary to conitue." --title="D E B M O D ERROR" --window-icon='error' --width=400 --height=300
		exit 1
	fi
        mkdir $nome
        build
;;
"I install a deb file")
#Instal a deb file
        install_deb
;;
*)menu_principale
;;
esac
exit 0
