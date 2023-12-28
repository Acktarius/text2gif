#!/bin/bash
read -p "Which text you want to turn in an animated gif? " text
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
#decompose en png
for ((i = 1 ; i <= ${#text} ; i++)); do
if [[ $i -lt 10 ]]; then
convert -background "#181a20" -fill "#007bff" -font Poppins-Regular -size x25  pango:"${text:0:$i}" first000$i.png
else
convert -background "#181a20" -fill "#007bff" -font Poppins-Regular -size x25  pango:"${text:0:$i}" first00$i.png
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
convert first000$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity East -extent ${length}x25 anim000$i.png
else
convert first00$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity East -extent ${length}x25 anim00$i.png
fi
done
#complement
for ((i = 1 ; i < ${#text} ; i++)); do
if [[ $i -lt 10 ]]; then
convert -background "#181a20" -fill "#007bff" -font Poppins-Regular -size x25  pango:"${text:$i:${#text}}" second000$i.png
else
convert -background "#181a20" -fill "#007bff" -font Poppins-Regular -size x25  pango:"${text:$i:${#text}}" second00$i.png
fi
done
#redimensionnement
for ((i = 1 ; i < ${#text} ; i++)); do
j=$(( ${#text} + $i ))
if [[ $i -lt 10 ]]; then
	if [[ $j -lt 10 ]]; then
convert second000$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity West -extent ${length}x25 anim000$j.png
	else
		if [[ $j -ge 100 ]]; then
convert second000$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity West -extent ${length}x25 anim0$j.png
		else
convert second000$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity West -extent ${length}x25 anim00$j.png
		fi

	fi
else
	if [[ $j -lt 10 ]]; then
convert second00$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity West -extent ${length}x25 anim000$j.png
	else
		if [[ $j -ge 100 ]]; then
convert second00$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
  -gravity West -extent ${length}x25 anim0$j.png
		else
convert second00$i.png -resize ${length}x25 -background "#181a20" -compose Copy \
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
