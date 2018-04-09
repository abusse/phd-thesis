#! /bin/bash
#### Description: Converts a dot to a tikz graph description while adding formating statements
#### Usage: dot-to-tex.sh input.dot output.tex
#### Written by: Anselm Busse

# make sure to use GNU sed on macOS
if [ "$(uname)" == "Darwin" ]; then
	SED=gsed  
else
	SED=sed
fi

# create scratch file and make sure it is empty
echo -n > /tmp/temp-$$.dot

# correct formating
while read -r p; do
	if [[ $p == *"fillcolor"* ]]; then
		FUNCTION=`echo "$p" | ${SED} 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\1/g' | sed 's/_/|/g'`
		NUM=`echo "$p" | ${SED} 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\2/g'`
		TOTAL=`echo "$p" | ${SED} 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\3/g'`
		TEXLBL="\\small \\begin{tabular}{c} ?{${FUNCTION}} \\\\ \\begin{tabular}{rr}Calls: & \\multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTAL} / 1000 | bc` \\cdot 10^6\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTAL}/${NUM} | bc` \\cdot 10^3\$ \\end{tabular}\\end{tabular}"
		echo "`echo -n "$p" | sed 's/\];//g'` ,texlbl=\"${TEXLBL}\"];" >> /tmp/temp-$$.dot
	elif [[ $p == *"->"* ]]; then
		PERCENT=`echo "$p" | ${SED} 's/.*\[label=\"\[\(.*\)%\]\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\1/g'`
		NUM=`echo "$p" | ${SED} 's/.*\[label=\"\(\[.*%\]\)\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\3/g'`
		TOTAL=`echo "$p" | ${SED} 's/.*\[label=\"\(\[.*%\]\)\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\2/g'`
		TEXLBL="\\small \\begin{tabular}{rr}\\multicolumn{2}{c}{\\normalsize [${PERCENT}\\%]} \\\\ Calls: & \\multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTAL} / 1000 | bc` \\cdot 10^6\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTAL} / ${NUM} | bc` \\cdot 10^3\$ \\end{tabular}"

		echo "`echo -n "$p" | sed 's/\];//g'` ,texlbl=\"${TEXLBL}\"];" >> /tmp/temp-$$.dot
	else 
		echo "${p}" >> /tmp/temp-$$.dot
	fi
done < $1

# create tex file
echo -n > $2
echo "\\begin{scaletikzpicturetoheight}{0.925\\textheight}" >> $2
echo "\\begin{tikzpicture}[>={Stealth[scale=1]},line join=bevel,scale=\\tikzscale, every node/.style={transform shape}]" >> $2
echo "\\setlength\\tabcolsep{2pt}" >> $2

dot2tex --autosize -ftikz /tmp/temp-$$.dot | ghead -n -6 | gtail -n +23 | ${SED} 's/|/_/g' | ${SED} 's/?/\\code/g' >> $2

echo "\\end{scaletikzpicturetoheight}" >> $2
