\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{llncsstandalone}[2025-05-27 v0.1 A derivative of llncs for standalone documents not included in proceedings]

\let\ifllncsstandalone@enabled\iftrue
\DeclareOption{nostandalone}{\let\ifllncsstandalone@enabled\iffalse}
\let\ifllncsstandalone@adjustmargins\iffalse
\DeclareOption{adjustmargins}{
  \let\ifllncsstandalone@adjustmargins\iftrue
}

% Delegate all other options to llncs
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{llncs}}
\ProcessOptions\relax
\LoadClass{llncs}

\ifllncsstandalone@adjustmargins
  % This is equivalent to 3cm margins (and the page shifted 0.5cm up)
  % on a4paper but gives an identical textblock on letterpaper.
  \RequirePackage[twoside=false, textwidth=150mm, textheight=237mm, vmarginratio=5:7, footskip=13mm]{geometry}
\fi

\ifllncsstandalone@enabled
 
\RequirePackage{xpatch}
\newcommand{\llncsstandalone@error}{\ClassError{llncsstandalone}{patching failed}{}}

% The llncs class is designed for conference proceedings, where each ToC
% entry and PDF bookmark is an entire paper, and page numbering is
% global. If we want to use it for a standalone paper, we'll need some
% tweaks.

% Remove title and authors from ToC (and PDF bookmarks)
% Loosely based on https://tex.stackexchange.com/a/47410 by egreg.
\let\llncsmaketitle\maketitle
\renewcommand{\maketitle}{%
  \begingroup%
     % Overriding \addtocontents appears to change the spacing below the
     % author block for some reason and appears to be unnecessary, so
     % let's not touch it.
     %\let\addtocontents\@gobbletwo%
     \let\addcontentsline\@gobblethree%
     \llncsmaketitle%
  \endgroup%
}

% Make ToC a section* instead of a chapter*
\xpatchcmd{\tableofcontents}{\chapter*}{\section*}{}{\llncsstandalone@error}
\AtBeginDocument{\renewcommand\contentsname{Contents}}

% Change depth settings:
% Include sections and subsections in ToC
\setcounter{tocdepth}{2}
% ... and in PDF bookmarks
\AtBeginDocument{
  \IfPackageLoadedTF{hyperref}{
    \hypersetup{bookmarksdepth=2}}{}
}

% Enable page numbers
\pagestyle{plain}

\fi  % llncsstandalone@enabled
