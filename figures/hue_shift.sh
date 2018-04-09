#! /bin/bash
#### Description: Shifts the color hue in traces possible necessary for printing
#### Usage: hue_shift.sh input.tex output.tex
#### Written by: Anselm Busse

echo -n > $2

while read -r p; do
	if [[ $p == *"\definecolor{fillcolor}{rgb}"* ]]; then
		COLORS=`echo "$p" | gsed 's/.*{rgb}{\(.*\)};/\1/g'`
		RED=`echo $COLORS | cut -d ',' -f 1-1`
		GREEN=`echo $COLORS | cut -d ',' -f 2-2`
		BLUE=`echo $COLORS | cut -d ',' -f 3-3`
		
		RED=`echo "scale=5;   (${RED}   + 0.176471) / 1.176471" | bc`
		GREEN=`echo "scale=5; (${GREEN} + 0.176471) / 1.176471" | bc`
		BLUE=`echo "scale=5;  (${BLUE}  + 0.176471) / 1.176471" | bc`
		
		GREEN=`echo "scale=5;
define value (r,g) {
if (r>0.15) {return g}
return 0.65
}
value(${RED},${GREEN})
" | bc`
		
		echo "$p" | gsed "s/\(.*{rgb}{\).*\(};\)/\1${RED},${GREEN},${BLUE}\2/g" >> $2
	else 
		echo "${p}" >> $2
	fi
done < $1

