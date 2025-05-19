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
latexmk

# See the compiled document for further documentation
xdg-open main.pdf
```
