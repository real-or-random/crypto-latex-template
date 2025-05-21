# A Modern LaTeX Template for Cryptography

## Getting Started

```sh
# Install cryptobib into your TEXMFHOME (defaults to $HOME/texmf).
# (It will be available to all your LaTeX documents, so this needs
# to be done only once.)
bibhome="$(kpsewhich -var-value TEXMFHOME)/bibtex/bib"
mkdir -p "$bibhome"
git clone https://github.com/cryptobib/export "$bibhome/cryptobib"

# Compile the document
cd src
latexmk

# See the compiled document for further documentation
xdg-open main.pdf
```

## Editor Configuration

### Emacs (AUCTeX and RefTeX)

Create a file `src/.dir-locals.el` with contents:

``` emacs-lisp
;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((TeX-command-default . "LaTeXMk")
         (TeX-master . "main"))))
```


Also, add the following to your configuration file:

```emacs-lisp
(setq reftex-use-external-file-finders t)
(setq reftex-external-file-finders
      '(("tex" . "kpsewhich -format=.tex %f")
        ("bib" . "kpsewhich -format=.bib %f")))
```
