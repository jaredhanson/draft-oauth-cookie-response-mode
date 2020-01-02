spec: spec.xml spec.txt

%.xml: %.md
	kramdown-rfc2629 $< >$@

%.txt: %.xml
	xml2rfc $< -o $@ --text

%.html: %.xml
	xml2rfc $< -o $@ --html
