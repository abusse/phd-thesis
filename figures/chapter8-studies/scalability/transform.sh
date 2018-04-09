#! /bin/bash

ghead -n -6 $1 | gtail -n +21 | gsed 's/$\\backslash$n/ \\\\ /g' | gsed 's/\\_/_/g' > output.tex

echo "%BEGIN-SIDEWAY" > temp.tex
echo "\\begin{scaletikzpicturetowidth}{0.9\\textwidth}" >> temp.tex
echo "\\begin{tikzpicture}[>={Stealth[scale=1]},line join=bevel,scale=\\tikzscale, every node/.style={transform shape}]" >> temp.tex
echo "\\setlength\\tabcolsep{2pt}" >> temp.tex

while read -r p; do
	if [[ $p == *"Total"* ]]; then
		HEAD=`echo "$p" | gsed 's/\(.*ellipse\] {\)\(.*\) \\\\.*Calls: \(.*\) \\\\.*Total: \(.*\) \\\\.*Avg: \(.*\)};/\1/g'`
		FUNCTION=`echo "$p" | gsed 's/.*ellipse\] {\(.*\) \\\\.*Calls: \(.*\) \\\\.*Total: \(.*\) \\\\.*Avg: \(.*\)};/\1/g'`
		NUM=`echo "$p" | gsed 's/.*ellipse\] {\(.*\) \\\\.*Calls: \(.*\) \\\\.*Total: \(.*\) \\\\.*Avg: \(.*\)};/\2/g'`
		TOTAL=`echo "$p" | gsed 's/.*ellipse\] {\(.*\) \\\\.*Calls: \(.*\) \\\\.*Total: \(.*\) \\\\.*Avg: \(.*\)};/\3/g'`
		echo "${HEAD}\\small \\begin{tabular}{c}\\code{${FUNCTION}} \\\\ \\begin{tabular}{rr}Calls: & \\multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTAL} / 1000 | bc` \\cdot 10^6\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTAL}/${NUM} | bc` \\cdot 10^3\$ \\end{tabular}\\end{tabular}};" >> temp.tex
	else 
		echo "${p}" >> temp.tex
	fi
done < output.tex

echo "\\end{scaletikzpicturetowidth}" >> temp.tex
echo "%END-SIDEWAY" >> temp.tex

cat temp.tex | gsed ':a;N;$!ba;s/\n\(\\draw (.\{0,10\}bp,.\{0,10\}bp) node {XXXXXXX};\)/ \1/g' | \
	gsed ':a;N;$!ba;s/\n\(\\draw (.\{0,10\}bp,.\{0,10\}bp) node {.\{0,10\}}; \\draw (.\{0,10\}bp,.\{0,10\}bp) node {XXXXXXX};\)/ \1/g' | \
	gsed ':a;N;$!ba;s/\n\(\\draw (.\{0,10\}bp,.\{0,10\}bp) node {.\{0,20\}}; \\draw (.\{0,10\}bp,.\{0,10\}bp) node {.\{0,10\}}; \\draw (.\{0,10\}bp,.\{0,10\}bp) node {XXXXXXX};\)/ \1/g' > temp2.tex

echo > output.tex

while read -r p; do
	if [[ $p == *"XXXXXXX"* ]]; then
		PERCENT=`echo "$p" | gsed 's/.*\[\(.\{0,10\}\)\\\%\].*/\1/g'`
		NUM=`echo "$p" | gsed 's/.*node {\(.\{0,10\}\)}.*\\draw (.\{0,10\}bp,.\{0,10\}bp) node {XXXXXXX};/\1/g'`
		TOTALO=`echo "$p" | gsed 's/.*node {\(.\{0,20\}\)}.*\\draw (.\{0,10\}bp,.\{0,10\}bp) node {\(.\{0,10\}\)}.*\\draw (.\{0,10\}bp,.\{0,10\}bp) node {XXXXXXX};/\1/g'`
		COORX=`echo "$p" | gsed 's/.*node {.\{0,10\}}.*\\draw (\(.\{0,10\}\)bp,.\{0,10\}bp) node {XXXXXXX};/\1/g'`
		COORY=`echo "$p" | gsed 's/.*node {.\{0,10\}}.*\\draw (.\{0,10\}bp,\(.\{0,10\}\)bp) node {XXXXXXX};/\1/g'`
		echo $PERCENT
		echo $TOTALO
		echo $COORX
		echo $COORY
		echo "\draw (${COORX}bp,`echo scale=2\; ${COORY} + 22.5 | bc`bp) node {\small \begin{tabular}{rr}\multicolumn{2}{c}{\normalsize [${PERCENT}\%]} \\\\ Calls: & \multicolumn{1}{c}{${NUM}} \\\\ Time: & \$`echo scale=2\; ${TOTALO} / 1000 | bc` \cdot 10^6\$ \\\\ Avg.: & \$`echo scale=2\; ${TOTALO} / ${NUM} | bc` \cdot 10^3\$ \end{tabular}};" >> output.tex
		#TOTALO=`echo "$p" | gsed 's/\(.*Total: &\)\(.*\)\( .*Avg.*\)/\2/g'`
		#echo $TOTALO
		#TOTALN=`echo "scale=2; $TOTALO / 1000" | bc`
		#AVGO=`echo "$p" | gsed 's/\(.*Avg: &\)\(.*\)\( .*end.*\\end.*\)/\2/g'`
		#echo $AVGO
		#AVGN=`echo "scale=2; $AVGO / 1000" | bc`
		#echo "${p}" | gsed 's/'"${AVGO}"'/$'"${AVGN}"' \\cdot 10^{3}$/g' | gsed 's/'"${TOTALO}"'/$'"${TOTALN}"' \\cdot 10^{6}$/g' >> output.tex
	else 
		echo "${p}" >> output.tex
	fi
done < temp2.tex