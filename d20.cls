% d20 System (3.5) Book
% Caio Freitas de Oliveira

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{d20book}
              [2020/06/05 v0.1
 d20 System LaTeX document class]
\LoadClass[10pt,utf8x,a4paper,final,twocolumn,openany]{book}
\RequirePackage{cuted}
\RequirePackage{lettrine}
\RequirePackage{xparse}
\RequirePackage{tabularx,booktabs}
\RequirePackage{imfellEnglish}
\RequirePackage[table]{xcolor}
\RequirePackage[outline]{contour}

\definecolor{TableColor}{HTML}{fdccbc}
\definecolor{QuoteColor}{HTML}{d76647}
\definecolor{ChapterColor}{HTML}{8f1703}

% Font settings
\renewcommand*\rmdefault{lmr}
\newcommand\textold[1]{{\imfellEnglish\itshape #1}}
\newcommand\tableheader{\imfellEnglish\scshape}
\renewcommand\textbf[1]{{\scshape\imfellEnglish #1}}
\renewcommand\textit[1]{{\slshape\imfellEnglish #1}}

% References
\newcommand{\skill}[1]{\hyperref[skill:#1]{#1}}
\newcommand{\feat}[1]{\hyperref[feat:#1]{#1}}
\newcommand{\spell}[1]{\emph{\hyperref[spell:#1]{#1}}}
\newcommand{\psionic}[1]{\emph{\hyperref[psionic:#1]{#1}}}
\newcommand{\tabref}[1]{\hyperref[tab:#1]{Table: #1}}


% Table of Contents
\renewcommand\tableofcontents{
	{
		\imfellEnglish
		\chapter*{\contentsname}
		\@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}
		\@starttoc{toc}
	}
}
\setcounter{tocdepth}{1}
\renewcommand\listoftables{%
	{
		\imfellEnglish
		\chapter*{\listtablename}%
		\@mkboth{\MakeUppercase\listtablename}{\MakeUppercase\listtablename}%
		\@starttoc{lot}%
	}
}

\newcommand{\cbold}[2][black]{
	\contourlength{0.001pt}\contournumber{1}\contour{#1}{#2}
}
% Chapter Name
\def\@makechapterhead#1{%
	{
		\parindent \z@ \imfellEnglish%
		\ifnum \c@secnumdepth >\m@ne%
			\if@mainmatter%
				\Large\ \@chapapp\space\thechapter\kern0.3em%
			\fi%
		\fi%
		\interlinepenalty\@M%
		\Huge\bfseries\color{ChapterColor}\raggedleft{
			\contourlength{0.2pt}\contournumber{10}\contour{ChapterColor}{
				\MakeUppercase{#1}
			}
		}
		\par\nobreak%
	}
}
% Caption
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\imfellEnglish#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    \imfellEnglish #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

% Add quotes
\newcommand{\Quote}[3][-.7em]{
	{
		\imfellEnglish\small
		\linespread{.9}
		{
			\slshape\color{black!50}
			\setlength\parindent{5pt}
			``#2''
			% \hrulefill
		}
		\ifx&#3&\else\begin{flushright}{\vspace{#1}\color{ChapterColor}--- #3}\end{flushright}\fi
	}
}
\newcommand{\Chapter}[3]{
	\chapter{#1}
	\begin{strip}
	\Quote{#2}{#3}
	\end{strip}
}

% Captilize
\newcommand{\Capitalize}[2]{\lettrine[lines=4]{#1}{#2}}
% Items
\newenvironment{itemize*}%
  {\begin{itemize}%
    \setlength{\itemsep}{.2em}%
    \setlength{\parskip}{.2em}}%
  {\end{itemize}}
\newenvironment{enumerate*}%
  {\begin{enumerate}%
    \setlength{\itemsep}{.2em}%
    \setlength{\parskip}{.2em}}%
  {\end{enumerate}}
% Different sections
\renewcommand \section {
	\@startsection{section}
	{1}
	{0pt}{.5em}{.5em}{\color{ChapterColor}\LARGE\scshape\raggedleft\imfellEnglish}
}
\renewcommand \subsection {
	\@startsection{subsection}
	{2}
	{0pt}{.5em}{.2em}{\color{ChapterColor}\Large\scshape\imfellEnglish}
}
\renewcommand \subsubsection {
	\@startsection{subsubsection}
	{3}
	{0pt}{.5em}{.2em}{\color{QuoteColor}\large\imfellEnglish}
}
\newcommand{\Skill}[2]{\subsection{#1 \normalsize(#2)} \label{skill:#1}}
\newcommand{\Feat}[7][General]{
\subsection{#2 \normalsize[#1]} \label{feat:#2}
#3

\ifx&#4&\else\textbf{Prerequisites:} #4

\fi
\ifx&#5&\else\textbf{Benefit:} #5

\fi
\ifx&#6&\else\textbf{Normal:} #6

\fi
\ifx&#7&\else\textbf{Special:} #7

\fi
}
\newcommand{\GFeat}[4][General]{\Feat[#1]{#2}{}{#3}{#4}{}{}}

\setlength{\columnsep}{.7cm}
\setlength{\voffset}{-1.54cm}
\setlength{\tabcolsep}{0.1cm}
\setlength{\textheight}{24cm}
\setlength{\belowcaptionskip}{.2em}

% NPC functions

% Table commands
%% Column types
\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{Z}[1]{>{\centering\arraybackslash}b{#1}}
\newcolumntype{r}[1]{>{\raggedleft\arraybackslash}b{#1}}
\newcolumntype{Y}[1]{>{\raggedright\arraybackslash}p{#1}}

%% Tables
\newcommand{\TinyTable}[4][\columnwidth]{
	\ifx&#2&\else\begin{table}[h!]\fi
	\ifx&#2&\else\caption{\label{tab:#2}#2}\fi
	\begin{tabularx}{#1}{@{}#3@{}}\rowcolors{2}{}{TableColor}\tiny
	#4\end{tabularx}
	\ifx&#2&\else\end{table}\fi
}
\newcommand{\Table}[4][h!]{
	\begin{table}[#1]
	\ifx&#2&\else\caption{\label{tab:#2}#2}\fi
	\rowcolors{2}{}{TableColor}\scriptsize
	\begin{tabularx}{\columnwidth}{@{}#3@{}}
	#4\end{tabularx}
	\end{table}
}
\newcommand{\TableOdd}[4][h!]{
	\begin{table}[#1]
	\ifx&#2&\else\caption{\label{tab:#2}#2}\fi
	\rowcolors{2}{TableColor}{}\scriptsize
	\begin{tabularx}{\columnwidth}{@{}#3@{}}
	#4\end{tabularx}
	\end{table}
}
\newcommand{\BigTable}[3]{
	\begin{table*}[h!]
	\rowcolors{0}{TableColor}{}
	\scriptsize
	\ifx&#1&\else\caption{\label{tab:#1}#1}\fi
	\begin{tabularx}{\textwidth}{#2}#3\end{tabularx}
	\end{table*}
}
\newcommand{\BigTablePair}[3]{
	\begin{table*}[ht!]
	\rowcolors{0}{}{TableColor}
	\scriptsize
	\ifx&#1&\else\caption{\label{tab:#1}#1}\fi
	\begin{tabularx}{\textwidth}{#2}#3\end{tabularx}
	\end{table*}
}
\newcommand{\Cell}[2][c]{
	\begin{tabular}{@{}#1@{}}
		#2
	\end{tabular}
}
\newcommand{\WarriorTable}[3][l l C C C l]{
	\BigTablePair{#2}{#1}{
		\tableheader Level & \tableheader Base Attack Bonus & \tableheader Fort Save & \tableheader Ref Save & \tableheader Will Save & \tableheader Special\\
		#3
	}
}
\newcommand{\MiniWarriorTable}[3][l l Z{.6cm} Z{.6cm} Z{.6cm} X]{
	\Table{#2}{#1}{
		\tableheader Level & \tableheader Base Attack Bonus & \tableheader Fort Save & \tableheader Ref Save & \tableheader Will Save & \tableheader Special\\
		#3
	}
}
\newcommand{\SpellcasterTable}[3]{
	\BigTablePair{#1}{l l Z{.6cm} Z{.6cm} Z{.6cm} X Z{#2} Z{#2} Z{#2} Z{#2} Z{#2} Z{#2} Z{#2} Z{#2} Z{#2} Z{#2}}{
		\rowcolor{white}
		\multirow[b]{2}{0.6cm}{\tableheader Level} & \multirow[b]{2}{2cm}{\tableheader Base\\ Attack Bonus} & \multirow[b]{2}{0.6cm}{\tableheader Fort Save} & \multirow[b]{2}{0.6cm}{\tableheader Ref Save} & \multirow[b]{2}{0.6cm}{\tableheader Will Save} & \multirow[b]{2}{*}{\tableheader Special} & \multicolumn{10}{c}{\tableheader Spells per day}\\
		\cmidrule[0.5pt]{7-16}
		&&&&&& \tableheader 0 & \tableheader 1 & \tableheader 2 & \tableheader 3 & \tableheader 4 & \tableheader 5 & \tableheader 6 & \tableheader 7 & \tableheader 8 & \tableheader 9 \\
		#3
	}
}
\newcommand{\HalfSpellcasterTable}[3]{
	\BigTablePair{#1}{l l C C C l Z{#2} Z{#2} Z{#2} Z{#2}}{
		\rowcolor{white}
		\multirow[b]{2}{0.6cm}{\tableheader Level} & \multirow[b]{2}{2cm}{\tableheader Base\\ Attack Bonus} & \multirow[b]{2}{0.6cm}{\tableheader Fort Save} & \multirow[b]{2}{0.6cm}{\tableheader Ref Save} & \multirow[b]{2}{0.6cm}{\tableheader Will Save} & \multirow[b]{2}{*}{\tableheader Special} & \multicolumn{4}{c}{\tableheader Spells per day}\\
		\cmidrule[0.5pt]{7-10}
		&&&&&& \tableheader 1 & \tableheader 2 & \tableheader 3 & \tableheader 4 \\
		#3
	}
}
\newcommand{\PsychicTable}[3][l l Z{.6cm} Z{.6cm} Z{.6cm} X >{\raggedleft\arraybackslash}b{1.8cm} >{\raggedleft\arraybackslash}b{1.8cm} >{\raggedleft\arraybackslash}b{1.8cm}]{
	\BigTablePair{#2}{#1}{
		\tableheader Level & \tableheader Base Attack Bonus & \tableheader Fort Save & \tableheader Ref Save & \tableheader Will Save & \tableheader Special & \tableheader Power Points per Day &  \tableheader Powers Known &  \tableheader Maximum Power Level Known \\
		#3
	}
}

\newcommand{\FeatTable}[3][l]{
	\BigTablePair{}{#1 p{4.8cm} X}{
		\tableheader #2 Feat & \textold{Prerequisites} & \textold{Benefit}\\
		#3
	}
}

\renewcommand{\arraystretch}{1.1}
\linespread{1.05}
\setcounter{secnumdepth}{0}
\renewcommand{\chaptermark}[1]{ \markboth{\scshape\MakeUppercase{#1}}{} }
\renewcommand{\sectionmark}[1]{ \markright{\scshape#1}{} }
\def\@evenhead{\imfellEnglish\thepage\hfil\leftmark}%
\def\@oddhead{\imfellEnglish{\rightmark}\hfil\thepage}%
\setlength{\intextsep}{.5em}
\setlength{\textfloatsep}{.5em}
% \setlength{\textfloatsep}{1em}
\setlength{\stripsep}{.5em}
\setlength{\aboverulesep}{0em}
\setlength{\belowrulesep}{0em}
\hyphenpenalty=10000
\endinput