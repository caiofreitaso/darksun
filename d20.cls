% d20 System (3.5) Book
% Caio Freitas de Oliveira

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{d20book}
              [2020/06/05 v0.1
 d20 System LaTeX document class]
\LoadClass[10pt,a4paper,final,twocolumn]{book}
\RequirePackage{cuted}
\RequirePackage{lettrine}
\RequirePackage{tabularx}
\RequirePackage[table]{xcolor}

\definecolor{TableColor}{HTML}{fb9c80}
\definecolor{QuoteColor}{HTML}{b45e45}
\definecolor{ChapterColor}{HTML}{702311}

% Table of Contents
\renewcommand\tableofcontents{
	\chapter*{
		\contentsname
		\@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}
	}
	\@starttoc{toc}
}
\setcounter{tocdepth}{1}

% Chapter Name
\def\@makechapterhead#1{%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \Large\bfseries \@chapapp\space \thechapter \kern 0.5em
      \fi
    \fi
    \interlinepenalty\@M
    \Huge \bfseries \color{ChapterColor} \raggedleft \uppercase #1\par\nobreak\p@
  }}

% Add quotes
\newcommand{\Quote}[2]{
	{
		\color{QuoteColor}
		\setlength\parindent{5pt}
		\scriptsize
		``#1''\begin{flushright}{--- #2}\end{flushright}
	}
}
\newcommand{\Chapter}[3]{
	\chapter{#1}
	\begin{strip}
	\Quote{#2}{#3}
	\end{strip}\par\nobreak
}

% Captilize
\newcommand{\Capitalize}[2]{\lettrine[lines=4,loversize=0.1]{#1}{#2}}

% Different sections
\renewcommand \section {
	\@startsection{section}
	{1}
	{0pt}{.5em}{.5em}{\color{ChapterColor}\normalfont\LARGE\bfseries\raggedleft\uppercase}
}
\renewcommand \subsection {
	\@startsection{subsection}
	{2}
	{0pt}{.5em}{.5em}{\color{QuoteColor}\normalfont\large\bfseries\uppercase}
}
\renewcommand \subsubsection {
	\@startsection{subsubsection}
	{3}
	{0pt}{.5em}{.5em}{\color{TableColor}\normalfont\normalsize\bfseries}
}

\setlength{\columnsep}{20pt}
\setlength{\voffset}{-1.54cm}
\setlength{\tabcolsep}{0.05cm}
\setlength{\textheight}{24cm}
% \setlength{\textwidth}{17cm}

% Table commands
\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcommand{\Table}[4][0.47\textwidth]{
	\begin{table}[h]
	\rowcolors{2}{white}{TableColor}\scriptsize
	\ifx&#2&\else\caption{#2}\vskip 5pt\fi
	\begin{tabularx}{#1}{@{}#3@{}}#4\end{tabularx}
	\end{table}
}
\newcommand{\BigTable}[3]{
	\begin{table*}[h!]
	\rowcolors{0}{TableColor}{white}\scriptsize
	\ifx&#1&\else\caption{#1}\vskip 5pt\fi
	\begin{tabularx}{\textwidth}{#2}#3\end{tabularx}
	\end{table*}
}
\newcommand{\BigTablePair}[3]{
	\begin{table*}[h!]
	\rowcolors{0}{white}{TableColor}\scriptsize
	\ifx&#1&\else\caption{#1}\vskip 5pt\fi
	\begin{tabularx}{\textwidth}{#2}#3\end{tabularx}
	\end{table*}
}
\newcommand{\Cell}[2][c]{
	\begin{tabular}{@{}#1@{}}
		#2
	\end{tabular}
}
\renewcommand{\arraystretch}{1.2}
\setcounter{secnumdepth}{0}
\endinput