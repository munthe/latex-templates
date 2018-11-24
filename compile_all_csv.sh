# Comppile all samples twice
for file in Sample/*.csv; do
	lualatex cards.tex $file 1
	lualatex cards.tex $file 1
	mv cards.pdf "${file%.csv}.pdf"
done
rm cards.aux cards.log 
