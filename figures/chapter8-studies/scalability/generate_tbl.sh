#! /bin/bash
#### Description: Simple loop to generate specific tables from the template
#### Written by: Anselm Busse


for cores in 16 32 64 128 254 ; do
	for delay in 0 500 1000 2000 ; do
		cat pipe-scale-tbl.tmpl | sed 's/XXXPEXXX/'"${cores}"'/g' | sed 's/XXXDELAYXXX/'"${delay}"'/g' > pipe-scale-tbl-${cores}c-${delay}b.tex
	done
done