#!/usr/bin/gawk -f

function crossref(str) {
	return gensub(/\[\[([^\]]+)]([^\]]+)]/, "<reference osisRef=\"\\1\">\\2</reference>", "g", str);
}

BEGIN {
	FS="\t";
	verse = "";
	printedWord = 0;
}

/^\s*$/ {
	print "</p><p>";
}

/.*/ {
	printedWord = 0;

	# print verse marker
	if ($1 != "") {
		if (verse != "")
			printf "<verse eID=\"%s\"/>\n", verse;
		verse = $1;
		printf "<verse sID=\"%s\" osisID=\"%s\"/>\n", verse, verse;
	}

	# print word
	if ($3 != "" || $4 != "" || $5 != "")
		printf "%s", $2;
	else
		printf "%s ", $2;

	# print variants
	if ($3 != "") {
		printf "<note type=\"alternate\" osisRef=\"%s\">%s</note> ", verse, $3;
	}

	# print crossrefs
	if ($4 != "") {
		printf "<note type=\"crossReference\" osisRef=\"%s\">%s</note> ", verse, crossref($4);
	}

	# print footnotes
	if ($5 != "") {
		printf "<note type=\"study\" osisRef=\"%s\">%s</note> ", verse, crossref($5);
	}
}

END {
	printf "<verse eID=\"%s\"/>\n", verse;
}
