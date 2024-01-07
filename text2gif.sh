#!/bin/bash
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
##################################################################
#functions
hex() {
local rgb=$(echo ${1/"rgb"/""}); rgb=${rgb#"("} ;rgb=${rgb%")"} ;rgb=${rgb/","/" "};
    printf "%02X%02X%02X" ${rgb//','/' '}
}

#read -p "Which text you want to turn in an animated gif? " text
#text entry
text=$(zenity --entry --title="Add Text" --text="Enter text you want to turn in animated gif" --width=400)
echo "$text"
if [[ -z "$text" ]]; then
echo "input text cannot be empty"
sleep 2
exit
else
if [[ ${#text} -gt 98 ]]; then
echo "input is too long !"
sleep 2
exit
else
#BackgroundColor
bckcolor=$(zenity --title="pick backgound color" --color-selection --show-palette --color=#181aff)
if [[ ${bckcolor:0:3} == "rgb" ]]; then
bckcolor=$(hex $bckcolor)
fi
case $? in
         0) echo "You selected #$bckcolor.";;
         1) echo "Color format incorrect."; exit ;;
        -1) echo "An unexpected error has occurred."; exit ;;
esac
#read -p "Background color, 6digits of hex format #" bckcolor
#if [[ "$bckcolor" =~ ^[0123456789abcdefABCDEF]{6}$ ]]; then
#  echo "valid #HEX color"
#else 
# echo "invalid format, default implemented " 
#bckcolor="181aff"
#fi
#
#TextColor
txtcolor=$(zenity --title="pick foregound color" --color-selection --show-palette --color=#007bff)
if [[ ${txtcolor:0:3} == "rgb" ]]; then
txtcolor=$(hex $txtcolor)
fi
case $? in
         0) echo "You selected #$txtcolor.";;
         1) echo "No color selected."; exit ;;
        -1) echo "An unexpected error has occurred."; exit ;;
esac

#decompose en png
for ((i = 1 ; i <= ${#text} ; i++)); do
if [[ $i -lt 10 ]]; then
convert -background "#$bckcolor" -fill "#$txtcolor" -font Arial-Regular -size x25  pango:"${text:0:$i}" first000$i.png
else
convert -background "#$bckcolor"  -fill "#$txtcolor" -font Arial-Regular -size x25  pango:"${text:0:$i}" first00$i.png
fi
done
# longueur horizontal du png
if [[ ${#text} -lt 10 ]]; then
length=$(identify first000${#text}.png | cut -d "x" -f 1 | cut -d " " -f 3)
else
length=$(identify first00${#text}.png | cut -d "x" -f 1 | cut -d " " -f 3)
fi

#redimensionnement
for ((i = 1 ; i <= ${#text} ; i++)); do
if [[ $i -lt 10 ]]; then
convert first000$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity East -extent ${length}x25 anim000$i.png
else
convert first00$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity East -extent ${length}x25 anim00$i.png
fi
done
#complement
for ((i = 1 ; i < ${#text} ; i++)); do
if [[ $i -lt 10 ]]; then
convert -background "#$bckcolor"  -fill "#$txtcolor" -font Arial-Regular -size x25  pango:"${text:$i:${#text}}" second000$i.png
else
convert -background "#$bckcolor"  -fill "#$txtcolor" -font Arial-Regular -size x25  pango:"${text:$i:${#text}}" second00$i.png
fi
done
#redimensionnement
for ((i = 1 ; i < ${#text} ; i++)); do
j=$(( ${#text} + $i ))
if [[ $i -lt 10 ]]; then
	if [[ $j -lt 10 ]]; then
convert second000$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim000$j.png
	else
		if [[ $j -ge 100 ]]; then
convert second000$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim0$j.png
		else
convert second000$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim00$j.png
		fi

	fi
else
	if [[ $j -lt 10 ]]; then
convert second00$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim000$j.png
	else
		if [[ $j -ge 100 ]]; then
convert second00$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim0$j.png
		else
convert second00$i.png -resize ${length}x25 -background "#$bckcolor"  -compose Copy \
  -gravity West -extent ${length}x25 anim00$j.png
		fi
	fi

fi
done

sleep 3
convert -delay 15 -loop 0 anim0*.png text_animated.gif
sleep 1
rm -f *.png
fi
fi
