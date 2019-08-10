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

function emph(str) {
	return gensub(/\{/, "\\\\emph{", "g", str);
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
	haschap = 0;
	if ($1 != "") {
		lastchap = chap(verse);
		thischap = chap($1);

		# we entered a new chapter
		if (lastchap != thischap) {
			printf "\n\n\\markboth{\\osisbook{%s} %s}{\\osisbook{%s} %s}\\lettrine[findent=5pt,nindent=0pt]{%s}{}\\ignorespaces\n", book($1), thischap, book($1), thischap, thischap;
			ast = "";
			haschap = 1;
		}
	}

	# print verse marker
	if ($1 != "") {
		verse = $1;
		if (!haschap)
			printf "%s\\putmarginpar{%s}{%s}", ast, verse, vnum(verse);
		else
			printf "%s", ast;
	}

	# print word
	if ($3 != "" || $4 != "" || $5 != "")
		printf "%s\\footnote{%s -- ", emph($2), vmark(verse);
	else
		printf "%s ", emph($2);

	# print variants
	if ($3 != "") {
		printf "%s", emph($3);

		if ($4 != "" || $5 != "")
			printf "; ";
	}

	# print crossrefs
	if ($4 != "") {
		printf "%s", emph(crossref($4));

		if ($5 != "")
			printf "; ";
	}

	# print footnotes
	if ($5 != "") {
		printf "%s", emph(crossref($5));
	}

	if ($3 != "" || $4 != "" || $5 != "")
		printf "} ";
}

END {
	printf "\n";
}
