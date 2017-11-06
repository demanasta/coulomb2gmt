%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                            %%
%% Class ``beamerLct''                                                        %%
%%                                                                            %%
%% A beamer template for Lecture presentations                                %%
%%                                                                            %%
%% Version: v1.0                                                              %%
%% Authors: Demitris G. Anastasiou                                            %%
%% License: MIT License (c) 2017 Demitris G. Anastasiou                       %%
%% GitHub Repo: https://github.com/demanasta/pres-templates/                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ************************** Class Identification ******************************
\newcommand\fileversion{1.0}
\newcommand\filedate{2017/06/25}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Classes/beamerLct}[\filedate\space A beamer template for lecture presentations by D. G. Anastasiou (v\fileversion)]
\typeout{https://github.com/demanasta/pres-template/}

% Copyright 2003--2007 by Till Tantau
% Copyright 2010 by Vedran Mileti\'c
% Copyright 2011 by Vedran Mileti\'c, Joseph Wright,
% Copyright 2017 Demitris G. Anastasiou for Lecture version
%
% This file may be distributed and/or modified
%
% 1. under the LaTeX Project Public License and/or
% 2. under the GNU Public License.
%
% See the file doc/licenses/LICENSE for more details.

\RequirePackage{beamerbasercs}
%\ProvidesClassRCS $Header: /Users/joseph/Documents/LaTeX/beamer/base/beamer.cls,v 332bfd3ce558 2013/12/02 16:41:31 joseph $
%[\beamer@version\space A class for typesetting presentations]


\RequirePackage{beamerbasemodes}
% Setup modes and check for article option

\beamer@transferifnecessary

\RequirePackage{ifpdf}

%
%
% Declarations used by beamer
%
%

% Public
\newdimen\headheight    % Total height of the headline (including depth)
\newdimen\headdp        % Depth of the headline
\newdimen\footheight    % Height of the footline
\newdimen\sidebarheight % Height of the sidebars

% Private
\newdimen\beamer@tempdim
\newdimen\beamer@finalheight
\newdimen\beamer@animht
\newdimen\beamer@animdp
\newdimen\beamer@animwd
\newdimen\beamer@leftmargin
\newdimen\beamer@rightmargin
\newdimen\beamer@leftsidebar
\newdimen\beamer@rightsidebar
\newdimen\beamer@boxsize
\newdimen\beamer@vboxoffset
\newdimen\beamer@descdefault
\newdimen\beamer@descriptionwidth

\newskip\beamer@lastskip

\newbox\beamer@areabox
\newbox\beamer@animcurrent
\newbox\beamer@animshowbox
\newbox\beamer@sectionbox
\newbox\beamer@logobox
\newbox\beamer@linebox

\newcount\beamer@sectioncount
\newcount\beamer@subsubsectionmax
\newcount\beamer@subsectionmax
\newcount\beamer@sectionmax
\newcount\beamer@totalheads
\newcount\beamer@headcounter
\newcount\beamer@partstartpage
\newcount\beamer@sectionstartpage
\newcount\beamer@subsectionstartpage
\newcount\beamer@animationtempa
\newcount\beamer@animationtempb
\newcount\beamer@xpos
\newcount\beamer@ypos
\newcount\beamer@showpartnumber
\newcount\beamer@currentsubsection
\newcount\beamer@coveringdepth
\newcount\beamer@sectionadjust
\newcount\beamer@tocsectionnumber


\newif\ifbeamer@sansmath
\newif\ifbeamer@altmode
\newif\ifbeamer@notes
\newif\ifbeamer@notesnormals
\newif\ifbeamer@compress
\newif\ifbeamer@centered
\newif\ifbeamer@draftmode
\newif\ifbeamer@suppressreplacements % decides whether fonts should be substituted
\newif\ifbeamer@frameswithnotesonly
\newif\ifbeamer@ignorenonframe
\newif\ifbeamer@autopdfinfo

\RequirePackage{beamerbaseoptions}
% For option management



%
%
% Document options
%
%

\beamer@suppressreplacementsfalse
\beamer@altmodefalse
\beamer@notesfalse
\beamer@notesnormalstrue
\beamer@compressfalse
\beamer@draftmodefalse
\beamer@frameswithnotesonlyfalse
\beamer@ignorenonframefalse
\beamer@autopdfinfotrue

\DeclareOptionBeamer{usepdftitle}[true]{\csname beamer@autopdfinfo#1\endcsname}
\DeclareOptionBeamer{envcountsect}{\beamer@countsecttrue}
\DeclareOptionBeamer{notheorems}{\beamer@blocksfalse}
\DeclareOptionBeamer{noamsthm}{\beamer@blocksfalse\beamer@amsfalse}

\DeclareOptionBeamer{compress}{\beamer@compresstrue}

\DeclareOptionBeamer{t}{\beamer@centeredfalse}
\DeclareOptionBeamer{c}{\beamer@centeredtrue}


\DeclareOptionBeamer{leqno}{\input{leqno.clo}}
\DeclareOptionBeamer{fleqn}{\input{fleqn.clo}}

\def\beamer@currentmode{beamer}
\DeclareOptionBeamer{handout}{\gdef\beamer@currentmode{handout}}
\DeclareOptionBeamer{trans}{\gdef\beamer@currentmode{trans}}

\DeclareOptionBeamer{pdftex}{}% Used by hyperref
\DeclareOptionBeamer{nativepdf}{}% Used by hyperref
\DeclareOptionBeamer{pdfmark}{}% Used by hyperref
\DeclareOptionBeamer{dvips}{}% Used by hyperref
\DeclareOptionBeamer{dviwindo}{}% Used by hyperref
\DeclareOptionBeamer{dvipsone}{}% Used by hyperref
\DeclareOptionBeamer{vtex}{}% Used by hyperref
\DeclareOptionBeamer{ps2pdf}{}% Used by hyperref

\DeclareOptionBeamer{ignorenonframetext}{\beamer@ignorenonframetrue}

\DeclareOptionBeamer{noamssymb}{\beamer@amssymbfalse}

\def\beamer@size{{size11.clo}}
\DeclareOptionBeamer{bigger}{\def\beamer@size{{size12.clo}}}
\DeclareOptionBeamer{smaller}{\def\beamer@size{{size10.clo}}}

\DeclareOptionBeamer{8pt}{\def\beamer@size{{size8.clo}}}
\DeclareOptionBeamer{9pt}{\def\beamer@size{{size9.clo}}}
\DeclareOptionBeamer{10pt}{\def\beamer@size{{size10.clo}}}
\DeclareOptionBeamer{11pt}{\def\beamer@size{{size11.clo}}}
\DeclareOptionBeamer{12pt}{\def\beamer@size{{size12.clo}}}
\DeclareOptionBeamer{14pt}{\def\beamer@size{{size14.clo}}}
\DeclareOptionBeamer{17pt}{\def\beamer@size{{size17.clo}}}
\DeclareOptionBeamer{20pt}{\def\beamer@size{{size20.clo}}}

\newif\ifsetDraft\setDraftfalse
\DeclareOptionBeamer{draft}{\setDrafttrue}
\pagenumbering{arabic}
\def\insertpagenumber{\thepage}

\def\beamer@activecjk{}
\def\beamer@hypercjk{}

\DeclareOptionBeamer{CJK}{\ExecuteOptionsBeamer{cjk}}
\DeclareOptionBeamer{cjk}{
  \def\beamer@hypercjk{\hypersetup{CJKbookmarks=true}}

  \def\beamer@activecjk{
    % Activate all >=128 characters.
    \count@=127
    \@whilenum\count@<254 \do{%
      \advance\count@ by 1
      \lccode`\~=\count@
      \catcode\count@=\active
      \lowercase{\def~{\kern1ex}}
    }
  }
}



% obsolete options
\DeclareOptionBeamer{notes}[show]{\csname beamer@notesaction@#1\endcsname}
\def\beamer@notesaction@hide{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``hide notes'' instead.}%
  \beamer@notesfalse}
\def\beamer@notesaction@show{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``show notes'' instead.}%
  \beamer@notestrue}
\def\beamer@notesaction@only{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``show only notes'' instead.}%
  \beamer@notestrue
  \beamer@notesnormalsfalse
  \nofiles
}
\def\beamer@notesaction@onlyslideswithnotes{%
  \beamer@notestrue%
  \beamer@frameswithnotesonlytrue%
  \nofiles
}
\DeclareOptionBeamer{inrow}{
  \ClassError{beamer}{``inrow'' no longer supported. Use ``compress'' instead.}{}}
\DeclareOptionBeamer{compressnotes}{%
  \ClassWarning{beamer}{``compressnotes'' is obsolete. Use
    \noexpand\setbeamertemplate{note page}[compressed] instead}
  \AtBeginDocument{\beamertemplatenotecompress}}
\DeclareOptionBeamer{notesonly}{
  \ClassWarning{beamer}{``notesonly'' is obsolete. Use beamer option
    ``show only notes'' instead.}
  \beamer@notesaction@only}
\DeclareOptionBeamer{blue}{
  \ClassWarning{beamer}{``blue'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.7}]{structure}}}
\DeclareOptionBeamer{red}{
  \ClassWarning{beamer}{``red'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.7,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{blackandwhite}{
  \ClassWarning{beamer}{``blackandwhite'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{brown}{
  \ClassWarning{beamer}{``brown'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.66,0.4,0.166}]{structure}}}
\DeclareOptionBeamer{slidescentered}{
  \ClassWarning{beamer}{``slidescentered'' is obsolete. Use ``c'' instead}
  \beamer@centeredtrue}
\DeclareOptionBeamer{slidestop}{
  \ClassWarning{beamer}{``slidestop'' is obsolete. Use ``t'' instead}
  \beamer@centeredfalse}
\DeclareOptionBeamer{sans}{%
  \ClassWarning{beamer}{``sans'' is obsolete. Just remove this option}
  \def\familydefault{\sfdefault}
  \def\mathfamilydefault{\sfdefault}
  \beamer@sansmathtrue
}
\DeclareOptionBeamer{serif}{%
  \ClassWarning{beamer}{``serif'' is obsolete. Use font theme ``serif'' instead}
  \def\familydefault{\rmdefault}
  \def\mathfamilydefault{\rmdefault}
  \beamer@sansmathfalse
}
\DeclareOptionBeamer{mathsans}{
  \ClassWarning{beamer}{``mathsans'' is obsolete. Use font theme ``serif'' with option ``butsansserifmath''}
  \def\mathfamilydefault{\sfdefault}\beamer@sansmathtrue}
\DeclareOptionBeamer{mathserif}{
  \ClassWarning{beamer}{``mathserif'' is obsolete. Use font theme ``serif'' with option ``onlymath''}
  \def\mathfamilydefault{\rmdefault}\beamer@sansmathfalse}
\DeclareOptionBeamer{professionalfont}{
  \ClassWarning{beamer}{``professionalfont'' is obsolete. Use font theme ``professionalfonts'' instead}
  \beamer@suppressreplacementstrue}

% has to be done here for compatibility
\def\familydefault{\sfdefault}
\def\mathfamilydefault{\sfdefault}
\beamer@sansmathtrue



\PassOptionsToPackage{bookmarks=true,%
  bookmarksopen=true,%
  pdfborder={0 0 0},%
  pdfhighlight={/N},%
  linkbordercolor={.5 .5 .5}}{hyperref}

\DeclareOptionBeamer{pgf}{\PassOptionsToPackage{#1}{pgf}}
\DeclareOptionBeamer{hyperref}{\PassOptionsToPackage{#1}{hyperref}}
\DeclareOptionBeamer{color}{\PassOptionsToPackage{#1}{color}}
\DeclareOptionBeamer{xcolor}{\PassOptionsToPackage{#1}{xcolor}}

\def\beamer@loaducs{}

\DeclareOptionBeamer{ucs}{%
  \ifpdf
    \PassOptionsToPackage{pdftex,unicode}{hyperref}
    \def\beamer@loaducs{
      \RequirePackage[hyperref]{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \else    
    \def\beamer@loaducs{
      \RequirePackage{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \fi
}
\DeclareOptionBeamer{utf8x}{\ExecuteOptionsBeamer{ucs}%
  \g@addto@macro\beamer@loaducs{\RequirePackage[utf8x]{inputenc}}%
}
\DeclareOptionBeamer{utf8}{
  \ClassWarning{beamer}{This option works no longer loads ucs.}
  \RequirePackage[utf8]{inputenc}
  \PassOptionsToPackage{unicode}{hyperref}
}

%
% Geometry: allows 16:10, 16:9, 14:9, 5:4 and 4:3 (default 4:3).
% Default value is set right after declaring width and height
% because it doesn't work otherwise.
%
\newlength\beamer@paperwidth%
\beamer@paperwidth 12.80cm%
\newlength\beamer@paperheight%
\beamer@paperheight 9.60cm%

\DeclareOptionBeamer{aspectratio}[43]{%
  \ifnum#1=1610%
    \beamer@paperwidth 16.00cm%
    \beamer@paperheight 10.00cm%
  \else\ifnum#1=169%
    \beamer@paperwidth 16.00cm%
    \beamer@paperheight 9.00cm%
  \else\ifnum#1=149%
    \beamer@paperwidth 14.00cm%
    \beamer@paperheight 9.00cm%
  \else\ifnum#1=54%
    \beamer@paperwidth 12.50cm%
    \beamer@paperheight 10.00cm%
  \else\ifnum#1=43%
    \beamer@paperwidth 12.80cm%
    \beamer@paperheight 9.60cm%
  \else\ifnum#1=32%
    \beamer@paperwidth 13.50cm%
    \beamer@paperheight 9.00cm%
  \else\ifnum#1=141%
    \beamer@paperwidth 14.85cm%
    \beamer@paperheight 10.50cm%
  \fi\fi\fi\fi\fi\fi\fi%
}

\RequirePackage[%
  papersize={\beamer@paperwidth,\beamer@paperheight},
  hmargin=1cm,%
  vmargin=0cm,%
  head=0.5cm,% might be changed later
  headsep=0pt,%
  foot=0.5cm% might be changed later
  ]{geometry}

%
% Process Options
%

\ExecuteOptionsBeamer{c}
\ProcessOptionsBeamer

% Load corresponding size file
\expandafter\input\beamer@size

% Filter class option list
\beamer@filterclassoptions


\RequirePackage{pgfcore}
% We need only the core stuff.

\RequirePackage{xxcolor}
% For color management (comes with pgf).

\RequirePackage{atbegshi}
% Normally loaded by hyperref but to be on the safe side ...

\RequirePackage[implicit=falsem, draft=false]{hyperref}
% For hyperlinks

\hypersetup{pdfcreator={LaTeX with Beamer class version \beamer@version}}

% Coding stuff
\beamer@loaducs
\beamer@hypercjk


\RequirePackage{beamerbaserequires}
% Beamer packages required both by presentation and article modes

% Defaults
\normalfont
\raggedright

\AtBeginDocument
{
  \addtocontents{toc}{\protect\beamer@endinputifotherversion{\beamer@version pt}}
  \addtocontents{nav}{\protect\beamer@endinputifotherversion{\beamer@version pt}}
}

\usetheme{default}


% Compatibility stuff
\csname beamer@loadlater\endcsname


%%------------------------------------------------------------------------------
%% Options added on BeamerPhD Class file
%%------------------------------------------------------------------------------

% ******************************* Font Option **********************************
\newif \ifdefineCustomFont\defineCustomFontfalse %To enable Separate abstract

\newif\ifPRES@customfont\PRES@customfontfalse % Enable Separate Abstract
\DeclareOption{customfont}{
  \PRES@customfonttrue
  \ClassWarning{beamerPub}{You have chosen an option that generates custom 
    fonts. Configure fonts on `preample.tex' file. If not, please remove 
    the option `customfont' from the document class and recompile. 
    Good luck with your writing!}
}

\ProcessOptions\relax%

\ifPRES@customfont
    \defineCustomFonttrue
\else
    \defineCustomFontfalse
\fi

\RequirePackage{tikz}
%\usetikzlibrary{calc}
\RequirePackage{xifthen}
% ******************************* Time Stamp ***********************************
% Compute the timestamp based on an idea of
% Tim Piessens \texttt{<Tim.Piessens@esat.kuleuven.ac.be>}.

\RequirePackage{datetime}


\newcommand{\timestamp}{compiled on \ifnum\day<10 0\fi\the\day.\,%
\ifnum\month<10 0\fi\the\month.\,%
\the\year\ at \xxivtime\,h}
% ******************************* Draft Mode ***********************************

% Initializing Draft Text
\newcommand\SetDraftText[1]{}
% Initializing Draft Version
\newcommand\SetDraftVersion[1]{}

% If Draft Mode is active
\ifsetDraft
% Disable figures in `draftmode' Change on `preample.tex` this option
\setkeys{Gin}{draft=false}

% Creates a Watermark Draft at the specified location.
% The settings can be tweaked in the preamble

% Draft text
\newcommand\drafttext{Draft}
\renewcommand\SetDraftText[1]{%
  \renewcommand\drafttext{#1}
}

% Draft Version
\newcommand\draftVersion{v1.0}
\renewcommand\SetDraftVersion[1]{%
  \renewcommand\draftVersion{#1}
}

% Draft Content
\newcommand\DraftContent{%
  \hspace*{\fill}
  \Large
  %\textcolor[gray]{\draftGrayScale}{% change gray color to red
  \textcolor[rgb]{1,0,0}{%
    {\drafttext}\space-\space{\draftVersion}\hspace{\stretch{1}}{\timestamp}
    \hspace*{\fill}
  }
}


% If NOT Draft Mode
\else 

\renewcommand\SetDraftText[1]{\ClassWarning{beamerPhD}{DraftMode is
    inactive, to use SetDraftText include `draftmode' in the document 
    class options.}}
% Draft Version
\renewcommand\SetDraftVersion[1]{\ClassWarning{beamerPhD}{DraftMode is
    inactive, to use SetDraftVersion include `draftmode' in the document
    class options.}}
\fi 

% ***************************** Define info variables **************************
% The name of your University
\newcommand{\@university}{}
\newcommand{\university}[1]{\renewcommand{\@university}{#1}}

% The name of your Department
\newcommand{\@dept}{}
\newcommand{\dept}[1]{\renewcommand{\@dept}{#1}}

% The name of your Laboratory
\newcommand{\@lab}{}
\newcommand{\lab}[1]{\renewcommand{\@lab}{#1}}
% 
% The name of your Title in Greek
\newcommand{\@lcttitle}{}
\newcommand{\lcttitle}[1]{\renewcommand{\@lcttitle}{#1}}

% The name of your Title in Greek
\newcommand{\@coursetitle}{}
\newcommand{\coursetitle}[1]{\renewcommand{\@coursetitle}{#1}}

% The name of your Title in Greek
\newcommand{\@courseinfo}{}
\newcommand{\courseinfo}[1]{\renewcommand{\@courseinfo}{#1}}

% The name of your degree title
\newcommand{\@degreetitle}{}
\newcommand{\degreetitle}[1]{\renewcommand{\@degreetitle}{#1}}

% The name of the author
\newcommand{\@authorname}{}
\newcommand{\authorname}[1]{\renewcommand{\@authorname}{#1}}

% The thesis of the author
\newcommand{\@authortitle}{}
\newcommand{\authortitle}[1]{\renewcommand{\@authortitle}{#1}}

% The city of your University
\newcommand{\@city}{}
\newcommand{\city}[1]{\renewcommand{\@city}{#1}}

% The date
\newcommand{\@coursedate}{}
\newcommand{\coursedate}[1]{\renewcommand{\@coursedate}{#1}}

% University Crest
\newcommand{\@crestleft}{}
\newcommand{\crestleft}[1]{\renewcommand{\@crestleft}{#1}}

% Department Crest
\newcommand{\@crestright}{}
\newcommand{\crestright}[1]{\renewcommand{\@crestright}{#1}}

% Thank u text
\newcommand{\@thankutext}{}
\newcommand{\thankutext}[1]{\renewcommand{\@thankutext}{#1}}

% Homepage Url
\newcommand{\@urlhome}{}
\newcommand{\urlhome}[1]{\renewcommand{\@urlhome}{#1}}

% Contact mail
\newcommand{\@contmail}{}
\newcommand{\contmail}[1]{\renewcommand{\@contmail}{#1}}

% LinkedIn url
\newcommand{\@urlin}{}
\newcommand{\urlin}[1]{\renewcommand{\@urlin}{#1}}

% GitHub Url
\newcommand{\@urlgh}{}
\newcommand{\urlgh}[1]{\renewcommand{\@urlgh}{#1}}

% Google plus Url
\newcommand{\@urlgp}{}
\newcommand{\urlgp}[1]{\renewcommand{\@urlgp}{#1}}

% TWitter Url
\newcommand{\@urltw}{}
\newcommand{\urltw}[1]{\renewcommand{\@urltw}{#1}}

% ******************************** Title Page **********************************
\definecolor{goldenyellow}{rgb}{1.0, 0.87, 0.0}
\definecolor{lava}{rgb}{0.81, 0.06, 0.13}
\definecolor{auburn}{rgb}{0.43, 0.21, 0.1}
\setbeamercolor{coursebox}{fg=auburn, bg=goldenyellow}

\renewcommand{\maketitle}{
\begin{frame}[plain]
  \begin{minipage}[t]{0.10\textwidth}
    \centering\raisebox{\dimexpr \topskip-\height}{\@crestleft}
  \end{minipage}\hfill
  \begin{minipage}[t]{0.76\textwidth}
    \centering \vspace*{-0.3cm}{\normalsize \textbf{\@university} \par}
    \vspace*{0.1cm}  {\small \@dept \par}
    \vspace*{0.1cm}  {\small \@lab  \par}
  \end{minipage}
  \begin{minipage}[t]{0.10\textwidth}
    \centering\raisebox{\dimexpr \topskip-\height}{\@crestright}
  \end{minipage}\hfill
  \vfill

  \hfill \begin{beamercolorbox}[wd=.5\paperwidth,leftskip=2cm,sep=1.5pt,center,rounded=false]{coursebox}
     \@coursetitle \par
     
     \footnotesize{\@courseinfo}
  \end{beamercolorbox}
  
  \centering
  \vspace*{.3cm}
  \Large\textbf{\textcolor{red!90!blue}{\@lcttitle}}\par\vfill
  %\small{\@degreetitle}\par\vfill
  \ifsetDraft
    \DraftContent
    \vspace*{-.5cm}
  \fi
  \vfill

\begin{flushleft}
  \normalsize\textbf{\@authorname}\par
  \footnotesize{\@authortitle}\par
\end{flushleft} 
\vspace*{-1cm}
\begin{flushright}
  \scriptsize\href{\@urlhome}{\@urlhome \space \faHome}\vskip-.15cm
  \color{red!90!blue}\rule{0.08\textwidth}{1pt}\par
  \scriptsize\href{mailto:\@contmail}{\@contmail \space \faEnvelope}\par
\end{flushright}\vfill
  
  \centering
  {\footnotesize\textbf{\@city, \@coursedate}}%\vfill
\end{frame}
}

% ****************************** Thank U Page **********************************
\newcommand{\makethanku}{
\begin{frame}[plain,b]\frametitle{}\framesubtitle{}
\vfill
  \begin{center}
%     \color{blue!90}\rule{0.02\textwidth}{1pt}\par
%     \color{blue!85}\rule{0.05\textwidth}{1pt}\par
    \color{blue!80}\rule{0.02\textwidth}{1pt}\par  
    \color{blue!70}\rule{0.05\textwidth}{1pt}\par
    \color{blue!60}\rule{0.1\textwidth}{1pt}\par
    \color{blue!50}\rule{0.2\textwidth}{1pt}\par
    \color{blue!40}\rule{0.3\textwidth}{1pt}\par
    \color{blue!30}\rule{0.45\textwidth}{1pt}\par  
    \color{blue!20}\rule{0.6\textwidth}{1pt}\par  
    \vskip.2cm
    \textcolor{red!85}{\Large\textbf{\@thankutext}}
    \color{blue!20}\rule{0.7\textwidth}{1pt}\par
    \color{blue!30}\rule{0.55\textwidth}{1pt}\par
    \color{blue!40}\rule{0.4\textwidth}{1pt}\par
    \color{blue!50}\rule{0.3\textwidth}{1pt}\par
    \color{blue!60}\rule{0.2\textwidth}{1pt}\par
    \color{blue!70}\rule{0.15\textwidth}{1pt}\par
    \color{blue!80}\rule{0.1\textwidth}{1pt}\par
    \color{blue!85}\rule{0.05\textwidth}{1pt}\par
    \color{blue!90}\rule{0.02\textwidth}{1pt}\par
  \end{center}
\vskip-2cm
\href{\@urlin}{\faLinkedin}\\
\href{\@urlgh}{\faGithub}\\
\href{\@urlgp}{\faGooglePlus}\\
\href{\@urltw}{\faTwitter} \hspace*{.1cm} \href{\@urlhome}{\faHome} \hspace*{.1cm} \href{mailto:\@contmail}{\faEnvelope} \hfill  \textcolor{red!80}{\scriptsize  \textit{compiled via \XeLaTeX}}\\
\vfill
\end{frame}
}

% ****************************** Q&A section ***********************************
\newcommand{\makeqahour}{
\begin{frame}[plain,b]\frametitle{}\framesubtitle{}
\vfill
  \begin{center}
    \includegraphics[height=.8\paperheight,draft=false]{Figs/darktableQA1.jpg}
  \end{center}
%\vskip-2cm

\begin{flushright}
\hfill\href{\@urlhome}{\faHome}
\href{mailto:\@contmail}{\faEnvelope}
\href{\@urlin}{\faLinkedin}
\href{\@urlgh}{\faGithub}
\href{\@urlgp}{\faGooglePlus}
\href{\@urltw}{\faTwitter}
\end{flushright}

%\textcolor{red!80}{\scriptsize  \textit{compiled via \XeLaTeX}}\\
\vfill
\end{frame}
}
% ****************** Chapter Mode - To print only selected chapters ************
\newif\ifdefineChapter\defineChapterfalse %To enable Separate abstract

\newif\ifPRES@chapter\PRES@chapterfalse % Enable Separate Abstract
\DeclareOption{chapter}{
  \PRES@chaptertrue
  \ClassWarning{beamerLct}{You have chosen an option that generates only 
    selected chapters with references, if this was intentional, ignore this
    warning. If not, please remove the option `chapter' from the document class
    and recompile. Good luck with your writing!}
}

\ProcessOptions\relax%

% ***************************** Chapter Mode ***********************************
% The chapter mode allows user to only print particular chapters with references
% All other options are disabled by default
% To include only specific chapters without TOC, LOF, Title and Front Matter
% To send it to supervisior for changes

\ifPRES@chapter
  \defineChaptertrue
  % Disable the table of contents, figures, tables, index and nomenclature
     \renewcommand{\maketitle}{}
%     \renewcommand{\tableofcontents}{}
    \renewcommand{\makethanku}{}
\else
    \defineChapterfalse
\fi

% ****************** Print Bibliography option *********************************
\newif\ifdefinePrintbib\definePrintbibfalse %To enable Separate abstract

\newif\ifPRES@printbib\PRES@printbibfalse % Enable Separate Abstract
\DeclareOption{printbib}{
  \PRES@printbibtrue
  \ClassWarning{beamerLct}{You have chosen an option that generates only 
    selected chapters with references, if this was intentional, ignore this
    warning. If not, please remove the option `printbib' from the document class
    and recompile. Good luck with your writing!}
}

\ProcessOptions\relax%

\ifPRES@printbib
    \definePrintbibtrue
\else
    \definePrintbibfalse
\fi

% \RequirePackage[backend=biber, style=authoryear, citestyle=alphabetic, sorting=nty, natbib=true]{biblatex}

% ********************* Progress Bar option ************************************
\newif\ifdefineProgrbar\defineProgrbarfalse %To enable Separate abstract

\newif\ifPRES@progrbar\PRES@progrbarfalse % Enable Separate Abstract
\DeclareOption{progrbar}{
  \PRES@progrbartrue
  \ClassWarning{beamerLct}{Υou have chosen an option that generates Progress bar
    in all frames of the presentation, if this was intentional, ignore this
    warning. If not, please remove the option `progrbar' from the document class
    and recompile. Good luck with your writing!}
}

\ProcessOptions\relax%

\ifPRES@progrbar
  \ifPRES@chapter
    % Disable progrbar on chapter mode
    \defineProgrbarfalse
  \else
    \defineProgrbartrue

\makeatletter
    \newcommand{\Progressbar@LabelColor}{black}
    \newcommand{\Progressbar@LabelText}{Label}
    \newcommand{\Progressbar@LabelWidth}{5}
%   Farbe, Text, Breite des Labels

    \newcommand{\Progressbar@BarWidth}{10}
    \newcommand{\Progressbar@BarHeight}{1}
    \newcommand{\Progressbar@BarColor}{yellow}
    \newcommand{\Progressbar@BarBorder}{black}
%   Breite, Höhe, Schriftfarbe des Prozentsatzes, Rahmenfarbe des Fortschrittbalkens

    \newcommand{\Progressbar@TodoA}{gray}
    \newcommand{\Progressbar@TodoB}{black}
%   Farbe 1 und 2 für den unerledigten Teil 

    \newcommand{\Progressbar@DoneA}{red}
    \newcommand{\Progressbar@DoneB}{blue}
%   Farbe 1 und 2 für den erledigten Teil   

    \newcommand{\Progressbar@Direction}{LTR}
%   Modus links nach rechts oder umgekehrt; umgekehrt ist buggy (no support yet)    

    \newcommand{\Progressbar@Completion}{50}
%   Fertigstellung in Prozent   

    \define@key{Progressbar}{LabelColor}[\Progressbar@LabelColor]{\renewcommand{\Progressbar@LabelColor}{#1}}
    \define@key{Progressbar}{LabelText}[\Progressbar@LabelText]{\renewcommand{\Progressbar@LabelText}{#1}}
    \define@key{Progressbar}{LabelWidth}[\Progressbar@LabelWidth]{\renewcommand{\Progressbar@LabelWidth}{#1}}

    \define@key{Progressbar}{BarWidth}[\Progressbar@BarWidth]{\renewcommand{\Progressbar@BarWidth}{#1}}
    \define@key{Progressbar}{BarHeight}[\Progressbar@BarHeight]{\renewcommand{\Progressbar@BarHeight}{#1}}
    \define@key{Progressbar}{BarColor}[\Progressbar@BarColor]{\renewcommand{\Progressbar@BarColor}{#1}}

    \define@key{Progressbar}{BarBorder}[\Progressbar@BarBorder]{\renewcommand{\Progressbar@BarBorder}{#1}}
    \define@key{Progressbar}{TodoA}[\Progressbar@TodoA]{\renewcommand{\Progressbar@TodoA}{#1}}
    \define@key{Progressbar}{TodoB}[\Progressbar@TodoB]{\renewcommand{\Progressbar@TodoB}{#1}}

    \define@key{Progressbar}{DoneA}[\Progressbar@DoneA]{\renewcommand{\Progressbar@DoneA}{#1}}
    \define@key{Progressbar}{DoneB}[\Progressbar@DoneB]{\renewcommand{\Progressbar@DoneB}{#1}}
    \define@key{Progressbar}{Direction}[\Progressbar@Direction]{\renewcommand{\Progressbar@Direction}{#1}}

    \define@key{Progressbar}{Completion}[\Progressbar@Completion]{\renewcommand{\Progressbar@Completion}{#1}}

    \newcommand{\Progressbar}[1]%
    {   \setkeys{Progressbar}{#1}
        % Progress Bars --------------------------------------------------
        \begin{tikzpicture}[overlay, remember picture,shift={($(current page.south west)+(0,0.05)$)}]

            \ifthenelse{ \( \Progressbar@Completion = 0 \) or \( \Progressbar@Completion = 100 \) }
                {   \newcommand{\TCA}{\Progressbar@TodoA}
                    \newcommand{\TCB}{\Progressbar@TodoB}
                    \newcommand{\DCA}{\Progressbar@DoneA}
                    \newcommand{\DCB}{\Progressbar@DoneB}
                }
                {   \newcommand{\TCA}{\Progressbar@TodoB !\Progressbar@Completion !\Progressbar@TodoA}
                    \newcommand{\TCB}{\Progressbar@TodoB}
                    \newcommand{\DCA}{\Progressbar@DoneA}
                    \newcommand{\DCB}{\Progressbar@DoneB !\Progressbar@Completion !\Progressbar@DoneA}
                }
            \ifthenelse{\equal{\Progressbar@Direction}{LTR}}
                {   \shade[left color=\DCA,right color=\DCB]%
                        (0,0) rectangle (\Progressbar@Completion * \Progressbar@BarWidth / 100,\Progressbar@BarHeight);
                    \shade[left color=\TCA,right color=\TCB]%
                        (\Progressbar@Completion * \Progressbar@BarWidth / 100,0)%
                        rectangle (\Progressbar@BarWidth,\Progressbar@BarHeight);
                }
                {   \shade[left color=\TCB,right color=\TCA]%
                        (0,0) rectangle (\Progressbar@Completion * \Progressbar@BarWidth / 100,\Progressbar@BarHeight);
                    \shade[left color=\DCB,right color=\DCA]%
                        (\Progressbar@Completion * \Progressbar@BarWidth / 100,0)%
                        rectangle (\Progressbar@BarWidth,\Progressbar@BarHeight);               
                }
            \draw (0,0) rectangle (\Progressbar@BarWidth,\Progressbar@BarHeight);
            \node[color=\Progressbar@BarColor] at%
                (\Progressbar@BarWidth / 10,\Progressbar@BarHeight / 2) {\Progressbar@Completion \%};
            \draw[color=white] (- \Progressbar@LabelWidth,0) -- %
                node[anchor=west,color=\Progressbar@LabelColor,text width=\Progressbar@LabelWidth]%
                {\Progressbar@LabelText} (- \Progressbar@LabelWidth,\Progressbar@BarHeight) ;
%               \typeout{todo c1 = \TCA}
%               \typeout{todo c2 = \TCB}
%               \typeout{done c1 = \DCA}
%               \typeout{done c2 = \DCB}
        \end{tikzpicture}
    }
\makeatother

\logo   {   \pgfmathsetmacro{\wid}{\the\paperwidth/28.45276-1}
                \pgfmathtruncatemacro{\prog}{100*\insertpagenumber/\insertdocumentendpage}
                \Progressbar{   LabelColor=yellow,%
                                            LabelText=,%
                                            LabelWidth=0,%
                                            BarWidth=\wid,%
                                            BarHeight=0.18,%
                                            BarColor=green,%
                                            BarBorder=black,%
                                            TodoA=red!20!white,%
                                            TodoB=red!70!gray,%
                                            DoneA=blue!70!cyan,%
                                            DoneB=blue!20!white,%
                                            Completion=\prog%
                                        }
            }

  \fi %< disable progrbar on chapter mode
\else
    \defineProgrbarfalse
\fi

