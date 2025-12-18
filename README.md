<!--
  Written by Tim Ruffing <me@real-or-random.org> and contributors
  SPDX-License-Identifier: CC0-1.0 or MIT-0
-->

# A Modern LaTeX Template for Cryptography

## A Word of Caution

This is my personal LaTeX template, including a handful of custom
packages and classes. I make this code available because I think that it
may help others. The code is commented but it lacks a full and proper
documentation, and while I may fix issues, I won't have the time to
provide user support.

I highly recommend paying attention to these wise words from [Ulrike
Fischer](https://tex.stackexchange.com/a/391022/61094):
> ### So if you want to use a (rather complex) template or a local custom class:
>
> Imagine that you get a fatal error and nothing compiles, or that someone tells you to change the header or the bibliography style, or that you realize in the middle of your work that something in the template doesn't fit your needs. Consider if and how you can handle such a problem.
> If the answer is one of these:
>
>   - I know enough about LaTeX to debug or adapt the template.
>   - I have a friend with enough knowledge who will help me.
>   - I have access to some professional support that will help me.
>   - I understand enough of the template and of LaTeX to be able to build a minimal example and ask on [tex.SX](https://tex.stackexchange.com/) or some other help site.
>
> Then go along and use the template if you like it. If you are relying on external support for problems perhaps ask them first if they recommend the template.

## Getting Started

### Create a New Repository From This Template

If you would like to use GitHub, just press the "Use this template"
button in the upper right corner of the page.

Otherwise, create a new repository from this template as follows:

``` sh
project_name="<your project name>"
mkdir "$project_name"
cd "$project_name"
git init
git fetch --depth=1 -n https://github.com/real-or-random/crypto-latex-template
git reset --hard $(git commit-tree "FETCH_HEAD^{tree}" -m "Import crypto-latex-template" -m "From: https://github.com/real-or-random/crypto-latex-template" -m "Commit: $(git rev-parse FETCH_HEAD)")
git add remote origin "<your remote URI>"
git push
```

### Install LaTeX

 - Arch Linux:
   ```sh
   pacman -S biber texlive-binextra texlive-publishers texlive-bibtexextra texlive-mathscience texlive-latexextra
   ```
 - (Your OS or distro not listed here? Please open a pull request!)

### Install CryptoBib

Install [CryptoBib](https://cryptobib.di.ens.fr/) into your `TEXMFHOME`
(defaults to `$HOME/texmf`). It will be available to all your LaTeX
documents, so this needs to be done only once.

```sh
texmfhome="$(kpsewhich -var-value TEXMFHOME)"
bibhome="$texmfhome/bibtex/bib"
mkdir -p "$bibhome"
git clone https://github.com/cryptobib/export "$bibhome/cryptobib"
mktexlsr "$texmfhome"

# Later, pull the latest additions to cryptobib
texmfhome="$(kpsewhich -var-value TEXMFHOME)"
bibhome="$texmfhome/bibtex/bib"
git -C "$bibhome/cryptobib" pull
mktexlsr "$texmfhome"
```

### Compile the Document and Read the Usage Notes

Use
[latexmk](https://www.cantab.net/users/johncollins/latexmk/index.html)
to compile the template:

``` sh
cd src
latexmk
```

Then open the document in your favorite PDF viewer. It contains further
usage notes for the template:

``` sh
xdg-open main.pdf
```

### Kill the License (Optional, for the Paranoid)

This is helpful if you want to distribute the repository contents to
others, e.g., a publisher. Removing the [COPYING.txt](COPYING.txt) file
prevents you from making the LaTeX sources of your paper available under
the [CC0 Public Domain Dedication
(CC0-1.0)](https://creativecommons.org/publicdomain/zero/1.0/) or the
[MIT No Attribution License
(MIT-0)](https://opensource.org/license/mit-0).

``` sh
git rm COPYING.txt
git commit -m "Remove COPYING.txt"
```

## Editor Configuration

### Emacs

#### AUCTeX

Create a file `src/.dir-locals.el` with contents:

``` emacs-lisp
;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((TeX-command-default . "LaTeXMk")
         (TeX-master . "main"))))
```

#### RefTeX / Citar

Also, add the following to your configuration file
(also for Citar, which uses RefTeX as a dependency):

```emacs-lisp
(setq reftex-use-external-file-finders t)
```

## Acknowledgements and Related Projects

 - [CryptoBib](https://cryptobib.di.ens.fr/):
   BibTeX database containing papers related to cryptography
   (used in this template)
 - [extract_from_bibliography](https://github.com/thomwiggers/extract_from_bibliography):
   Extract bib entries from big bibliographies
   (used in this template)
 - [citerus](https://github.com/matteocam/citerus):
   A command-line tool to search CryptoBib
 - [bips2bib](https://github.com/real-or-random/bips2bib):
   Generate a BibTeX file from the BIPs repository (Bitcoin Improvement Proposals)
