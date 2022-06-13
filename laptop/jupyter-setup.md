# pacakges required for pdf printing

texlive-latex
texlive-adjustbox
texlive-upquote
texlive-eurosym
texlive-ucs
texlive-ulem
texlive-rsfs
texlive-jknapltx
texlive-palatino
texlive-mathpazo
texlive-gsftopk
texlive-updmap-map
texlive-bibtex

# for code formating

```console
conda install -c conda-forge black
jupyter labextension install @ryantam626/jupyterlab_code_formatter
conda install -c conda-forge jupyterlab_code_formatter
jupyter serverextension enable --py jupyterlab_code_formatter
```
