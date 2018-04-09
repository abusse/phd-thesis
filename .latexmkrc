$ENV{'TEXINPUTS'}='./lib/:' . $ENV{'TEXINPUTS'};

$clean_ext = "run.xml pdfa.xmpi mw lol";
$clean_full_ext = "run.xml pdfa.xmpi mw lol";

$pdf_mode = 1; # tex -> pdf

@default_files = ('thesis-main.tex');

# When the source file uses bbl files for bibliography, run bibtex or biber as needed to regenerate the bbl files.
$bibtex_use = 2;

$pdflatex = 'pdflatex -shell-escape %O %S';
