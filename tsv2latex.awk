#!/usr/bin/gawk -f

function crossref(str) {
	return gensub(/\[\[([^\]]+)]([^\]]+)]/, "\\2", "g", str);
}

function vnum(str) {
	return gensub(/.+\..+\.(.+)/, "\\1", "g", str);
}

function vmark(str) {
	return gensub(/.+\.(.+)\.(.+)/, "\\1.\\2", "g", str);
}

function chap(str) {
	return gensub(/.+\.(.+)\..+/, "\\1", "g", str);
}

function book(str) {
	return gensub(/(.+)\..+\..+/, "\\1", "g", str);
}

BEGIN {
	FS="\t";
	verse = "";
}

/^\s*$/ {
	printf "\n\n";
}

/.*/ {
	ast = "\\textasteriskcentered";
	if ($1 != "") {
		lastchap = chap(verse);
		thischap = chap($1);

		# we entered a new chapter
		if (lastchap < thischap) {
			printf "\n\n\\markboth{\\osisbook{%s} %s}{\\osisbook{%s} %s}\\lettrine[findent=5pt,nindent=0pt]{%s}{}\n", book($1), thischap, book($1), thischap, thischap;
			ast = "";
		}
	}

	# print verse marker
	if ($1 != "") {
		verse = $1;
		printf "%s\\putmarginpar{%s}{%s}", ast, verse, vnum(verse);
	}

	# print word
	if ($3 != "" || $4 != "" || $5 != "")
		printf "%s\\footnote{%s -- ", $2, vmark(verse);
	else
		printf "%s ", $2;

	# print variants
	if ($3 != "") {
		printf "%s", $3;

		if ($4 != "" || $5 != "")
			printf "; ";
	}

	# print crossrefs
	if ($4 != "") {
		printf "%s", crossref($4);

		if ($5 != "")
			printf "; ";
	}

	# print footnotes
	if ($5 != "") {
		printf "%s", crossref($5);
	}

	if ($3 != "" || $4 != "" || $5 != "")
		printf "} ";
}

END {
	printf "\n";
}
