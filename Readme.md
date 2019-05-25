OSIS tools
==========

This is a tools library for preprocessing files to compose OSIS bibles. There
is still much manual work to do and you can find many information on the
official sword web sites (crosswire etc).

**The goal** of this project is to provide tools to process one type of
source files to valid OSIS bibles (primarily) and other formats, too.

Features
--------

At the moment I'm working on these things:

- proper transformation to OSIS bible
- "good" LaTeX support (print)

OSIS export
-----------

See the `tsv2osis.awk` script. This transforms the described `.tsv` file
format into OSIS `.xml` files.

LaTeX export
------------

See the `tsv2latex.awk` script. The resulting file needs an additional LaTeX
framework to become a valid LaTeX document. You can use `cat` to process file
headers and footers to "form" this document:

```latex
\documentclass[a4paper]{scrbook}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{osistools} % the script!

\begin{document}
\begin{center}
\osisbook{Matt}
\end{center}

\begin{multicols}{2}

% insert your document here, e.g. with \input

\end{multicols}
\end{document}
```
