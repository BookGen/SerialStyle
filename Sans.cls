\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Sans}

%%  Class loading and defaults:  %%

\LoadClass[ebook, 12pt, openany, twoside, extrafontsizes, showtrims]{memoir}

\RequireXeTeX

%%  Font and language setup:  %%

\RequirePackage{fontspec, polyglossia}
\setmainlanguage[variant=uk,ordinalmonthday=false]{english}
\setmainfont{Lato}
\newfontfamily{\ostt}{Old Standard TT}
\newcommand{\subs}[1]{\raisebox{-.35ex}{\scriptsize #1}}
\newcommand{\supers}[1]{\raisebox{.7ex}{\scriptsize #1}}

\RequirePackage{metalogo}

\RequirePackage{soul} % Used in title

\RequirePackage{newunicodechar}
\newunicodechar{⸺}{\makebox[2em][s]{\textemdash\hss\textemdash\hss\textemdash}} % Lato requires adjustment to remove space
\newunicodechar{⁓}{\scalebox{1.7}[1.35]{\textasciitilde}} % Not in Lato

%%  Page geometry:  %%

\settypeblocksize{486.9pt}{295pt}{*} % This gives 28 lines per page which is my preferred text height
\setlrmargins{*}{*}{1} % Equal horizontal margins
\setulmargins{*}{*}{1} % Equal vertical margins
\setheadfoot{\baselineskip}{24pt}
\setheaderspaces{*}{12pt}{*}
% \setstocksize{11in}{8.5in} % This sets the page up on letter stock
% \setpagecc{\paperheight}{\paperwidth}{*}  %  This centres the page on the stock
% \trimFrame
\showtrimsoff
\checkandfixthelayout[nearest]
\newlength{\smallheight}
\newlength{\smallwidth}
\setlength{\smallheight}{387.5pt}  %  This height creates a faux-centered (actually about a quarter-inch closer to the top) small page.
\setlength{\smallwidth}{274pt}  %  This mimics the 1/sqrt(2) ratio of the page

%%  Empty last page:  %%

\AtEndDocument{\atendtext\cleartoevenpage[\null\thispagestyle{cleared}]\null\pagestyle{cleared}}

%%  Frame formatting:  %%

\setlength{\fboxrule}{4.5pt}
\setlength{\fboxsep}{5pt}

%%  Stamp marks:  %%

\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}
\RequirePackage[pages=some]{background}
\newcommand{\textmark}{\backgroundsetup{
    contents={\ostt\HUGE\bfseries\framebox{\titleinfo}},
    color={black},
    angle={24},
    opacity={1},
    scale={1},
    position={-5pc,-4pc},
    nodeanchor={north west}
}\BgThispage}

%%  List formatting:  %%

\RequirePackage[inline]{enumitem}

%%  Date/time setup:  %%

\RequirePackage[english, cleanlook]{isodate}

%%  Quotation setup:  %%

\RequirePackage[style=french,french=guillemets]{csquotes}
\DeclareQuoteStyle[guillemets]{french}{« }[» ]{ »}{« }[» ]{ »}

%%  Footnote formatting:  %%

\footmarkstyle{#1.\hfill}
\setlength{\footmarkwidth}{1.7em}
\setlength{\footmarksep}{-1.7em}
\setlength{\footparindent}{1.7em}
\setlength{\footnotesep}{\onelineskip}
\setfootins{20pt plus 12pt minus 8pt}{16pt}
\feetbelowfloat
\renewcommand{\@makefntext}[1]{\makefootmark #1}
\renewcommand{\foottextfont}{\scriptsize}

%%  Chapter formatting:  %%

\makechapterstyle{ANDY}{
	\renewcommand{\chapterheadstart}{\vspace*{\beforechapskip}\hspace{1.5em}}
	\renewcommand*{\printchaptername}{}
	\renewcommand*{\chapternamenum}{}
	\renewcommand*{\afterchapternum}{\enspace}
	\renewcommand*{\printchapternonum}{}
	\renewcommand*{\chapnumfont}{\ostt\huge\bfseries}
	\renewcommand*{\chaptitlefont}{\ostt\huge\bfseries}
	\setlength{\beforechapskip}{48pt}
	\setlength{\afterchapskip}{34pt plus 6pt minus 2pt}
}
\makechapterstyle{SANDY}{
	\renewcommand{\chapterheadstart}{\vspace*{\beforechapskip}\hspace{1.5em}\textmark}
	\renewcommand*{\printchaptername}{}
	\renewcommand*{\chapternamenum}{}
	\renewcommand*{\afterchapternum}{\enspace}
	\renewcommand*{\printchapternonum}{}
	\renewcommand*{\chapnumfont}{\ostt\huge\bfseries}
	\renewcommand*{\chaptitlefont}{\ostt\huge\bfseries}
	\setlength{\beforechapskip}{48pt}
	\setlength{\afterchapskip}{34pt plus 6pt minus 2pt}
}

\copypagestyle{chapter}{plain}
\makeevenhead{chapter}{}{\tiny\copyrightinfo}{}
\makeoddhead{chapter}{}{\tiny\copyrightinfo}{}

%%  Lettrines:  %%

\newcommand*{\lettrine}[1]{\textbf{#1}\quad}

%%  Breaks:  %%

\setlength{\pfbreakskip}{32pt}
\renewcommand*{\pfbreakdisplay}{\bigskip·\quad ·\quad ·\quad ·\quad ·\bigskip}

%%  The copyright:  %%

\newcommand{\makecopyright}{
	\vfill
	{
		\parindent0pt\tiny
		\detailsinfo
		\par\bigskip
		\par\copyrightinfo
		\par\medskip
		\par This draft compiled \today{} at \printtime.
		\par\editioninfo{} Edition, \draftinfo{}.
		\par\bigskip
		\par Book design by the KIBI Gô.
		\par\medskip
		\par This work is formatted via \XeLaTeX{}.
		Body text has been set in 12pt Lato.
		Headings have been set in Old Standard TT.
		\par\bigskip
		\par\vfill
	}
}

%%  Option handling:  %%

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

\ProcessOptions\relax

%%  Defaults:  %%

\RequirePackage{fmtcount}
\renewcommand{\thechapter}{\padzeroes[2]{\decimal{chapter}}}
\setsecnumdepth{chapter}
\pagenumbering{arabic}
\openany
\pagestyle{simple}
\chapterstyle{ANDY}
\newcommand{\atendtext}{\par\vfill\centering\pagebreak[1]\null\vfill\parbox[b]{\textwidth}{\tiny \detailsinfo\nolinebreak\qquad \copyrightinfo Text design by the KIBI Gô. This work was formatted via \XeLaTeX{}, and this draft was compiled \today{} at \printtime{}.\nolinebreak\qquad Body text has been set in 12pt Lato. Headings have been set in Old Standard TT.\nolinebreak\qquad This has been the \ordinalstring{chapter} chapter of \seriesinfo{} – \titleinfo{}. Thank you for reading.\lastlinerulefill}}
\tolerance=5000

%%  Matter handling:  %%

\newcounter{lastfmpage}
\renewcommand{\frontmatter}{
    \cleardoublepage
    \openright
    \pagenumbering{roman}
    \pagestyle{simple}
    \chapterstyle{ANDY}
    \makeevenhead{chapter}{}{}{}
    \makeoddhead{chapter}{}{}{}
    \renewcommand{\atendtext}{}
    \renewcommand{\mainchapterstyle}{7c}
}
\renewcommand{\mainmatter}{
    \cleardoublepage
    \setcounter{lastfmpage}{\value{page}}
    \pagenumbering{arabic}
    \openany
    \pagestyle{simple}
    \setcounter{chapter}{0}
    \chapterstyle{SANDY}
    \makeevenhead{chapter}{}{}{}
    \makeoddhead{chapter}{}{}{}
}
\renewcommand{\backmatter}{
    \cleardoublepage
    \pagenumbering{roman}
    \setcounter{page}{\value{lastfmpage}}
    \openright
    \addtocontents{toc}{\vspace{12pt}}
    \chapterstyle{ANDY}
    \makeevenhead{chapter}{}{}{}
    \makeoddhead{chapter}{}{}{}
}