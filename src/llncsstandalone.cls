%% llncsstandalone.cls
%% Copyright Tim Ruffing and contributors
%% SPDX-License-Identifier: LPPL-1.3c+
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2008 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is:
%   Tim Ruffing <me@real-or-random.org>
%
% Please report issues at:
%   https://github.com/real-or-random/crypto-latex-template
%
% This work consists of this file.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{llncsstandalone}[2025-06-16 v1.0 llncs derivative for standalone papers]

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
