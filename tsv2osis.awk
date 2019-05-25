#!/usr/bin/gawk -f

function crossref(str) {
	return gensub(/\[\[([^\]]+)]([^\]]+)]/, "<reference osisRef=\"\\1\">\\2</reference>", "g", str);
}

function chap(str) {
	return gensub(/.+\.(.+)\..+/, "\\1", "g", str);
}

function chapmark(str) {
	return gensub(/(.+\..+)\..+/, "\\1", "g", str);
}

function emph(str) {
	return gensub(/\{(.+)\}/, "<hi type=\"italic\">\\1</hi>", "g", str);
}

BEGIN {
	FS="\t";
	verse = "";
	firstchapter = 1;

	printf("<p>\n");
}

/^\s*$/ {
	print "</p><p>";
}

/.*/ {
	if ($1 != "") {
		# first end last verse
		if (verse != "")
			printf "<verse eID=\"%s\"/>\n", verse;

		lastchap = chap(verse);
		thischap = chap($1);

		# we entered a new chapter
		if (lastchap < thischap) {
			lastchapmark = chapmark(verse);
			thischapmark = chapmark($1);
			if (firstchapter == 0) {
				printf "<chapter eID=\"%s\"/>", lastchapmark;
			}
			printf "<chapter sID=\"%s\" osisID=\"%s\">\n", thischapmark, thischapmark;
			firstchapter = 0;
		}
	}

	# print verse marker
	if ($1 != "") {
		verse = $1;
		printf "<verse sID=\"%s\" osisID=\"%s\"/>\n", verse, verse;
	}

	# print word
	if ($3 != "" || $4 != "" || $5 != "")
		printf "%s", emph($2);
	else
		printf "%s ", emph($2);

	# print variants
	if ($3 != "") {
		printf "<note type=\"alternate\" osisRef=\"%s\">%s</note>", verse, emph(crossref($3));
	}

	# print footnotes
	if ($5 != "") {
		printf "<note type=\"study\" osisRef=\"%s\">%s</note>", verse, emph(crossref($5));
	}

	# print crossrefs
	if ($4 != "") {
		printf "<note type=\"crossReference\" osisRef=\"%s\">%s</note> ", verse, emph(crossref($4));
	}

	if ($3 != "" || $4 != "" || $5 != "")
		printf " ";
}

END {
	printf "<verse eID=\"%s\"/>\n", verse;
	printf "</p>\n";
	printf "<chapter eID=\"%s\"/>\n", chapmark(verse);
}
