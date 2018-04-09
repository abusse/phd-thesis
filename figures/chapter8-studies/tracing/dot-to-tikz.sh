#! /bin/bash
#### Description: Converts a dot file to a tikz description while adding formating statements
#### Usage: dot-to-tex.sh input.dot output.tikz
#### Written by: Anselm Busse

echo -n > /tmp/temp-$$.dot

while read -r p; do
	if [[ $p == *"fillcolor"* ]]; then
		FUNCTION=`echo "$p" | gsed 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\1/g' | sed 's/_/|/g'`
		NUM=`echo "$p" | gsed 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\2/g'`
		TOTAL=`echo "$p" | gsed 's/.*\[label=\"\(.*\)\\\\nCalls: \(.*\)\\\\nTotal: \(.*\)\\\\nAvg: \(.*\)\".*/\3/g'`
		TEXLBL="\\small \\begin{tabular}{c} ?{${FUNCTION}} \\\\ \\begin{tabular}{rr}Calls: & \\multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTAL} | bc` \\cdot 10^3\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTAL}/${NUM} | bc` \\cdot 10^3\$ \\end{tabular}\\end{tabular}"
		echo "`echo -n "$p" | sed 's/\];//g'` ,texlbl=\"${TEXLBL}\"];" >> /tmp/temp-$$.dot
	elif [[ $p == *"->"* ]]; then
		PERCENT=`echo "$p" | gsed 's/.*\[label=\"\[\(.*\)%\]\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\1/g'`
		NUM=`echo "$p" | gsed 's/.*\[label=\"\(\[.*%\]\)\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\3/g'`
		TOTAL=`echo "$p" | gsed 's/.*\[label=\"\(\[.*%\]\)\\\\n\([0-9]*\.[0-9]*\)\\\\n\(.*\)\".*/\2/g'`
		TEXLBL="\\small \\begin{tabular}{rr}\\multicolumn{2}{c}{\\normalsize [${PERCENT}\\%]} \\\\ Calls: & \\multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTAL} | bc` \\cdot 10^3\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTAL} / ${NUM} | bc` \\cdot 10^3\$ \\end{tabular}"

		echo "`echo -n "$p" | sed 's/\];//g'` ,texlbl=\"${TEXLBL}\"];" >> /tmp/temp-$$.dot
	else 
		echo "${p}" >> /tmp/temp-$$.dot
	fi
done < $1

echo -n > $2
echo "\\begin{scaletikzpicturetowidth}{0.9\\textwidth}" >> $2
echo "\\begin{tikzpicture}[>={Stealth[scale=1]},line join=bevel,scale=\\tikzscale, every node/.style={transform shape}]" >> $2
echo "\\setlength\\tabcolsep{2pt}" >> $2

dot2tex --autosize -ftikz /tmp/temp-$$.dot | ghead -n -6 | gtail -n +23 | gsed 's/|/_/g' | gsed 's/?/\\code/g' >> $2

echo "\\end{scaletikzpicturetowidth}" >> $2
