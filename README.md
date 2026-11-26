# Project m68k

Source for the project site: https://dsheffie.github.io/m68k-project/

```sh
pip install pyyaml "mkdocs<2" mkdocs-material
tools/pull_uisa.sh ../uisa   # regenerate uisa's manual, PDF and docs into docs/uisa/
tools/pull_formal_spec.sh ../m68k-formal-spec   # docs/formal-spec.md from its READMEs
mkdocs serve
```

`.github/workflows/docs.yml` does the same against dsheffie/uisa and dsheffie/m68k-formal-spec and deploys to `gh-pages`.
