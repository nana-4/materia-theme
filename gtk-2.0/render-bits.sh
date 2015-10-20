#! /bin/bash
#
# Yeah this script is pretty bad and ugly, so?
#
INKSCAPE=/usr/bin/inkscape
SVG=assets.svg
LISTFILE=assets.txt
for filename in `cat $LISTFILE`
do
	DIR=`echo $filename | cut -f1 -d '/'`
	if [ '!' -d $DIR ]; 
		then mkdir $DIR; 
	fi
	ID=`echo $filename | tr '/' '_'`
	$INKSCAPE $SVG -i $ID -e $filename.png
done
