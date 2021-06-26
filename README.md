# Quarto render for Github Actions

This repository is a demonstration of the `quarto-render` ([link](https://github.com/pommevilla/quarto-render)) Github action on a Quarto project [with freeze](https://quarto.org/docs/books/book-authoring.html?q=freeze#freezing). 

The documents in this directory contain R and Python code that require various libraries to complete their computations. By setting `freeze: true` in `_quarto.yml`,  computations are not re-executed at render time and documents are rendered quickly. This means we can use the `quarto-render` to quickly generate our documents as part of an Action. Below is the workflow used by this directory that uses the `quarto-render` Github action and pushes the resulting documents to the `gh-pages` branch with `action-gh-pages` ([link](https://github.com/peaceiris/actions-gh-pages)). 

## Github Workflow

```yaml
# https://github.com/pommevilla/friendly-dollop/blob/master/.github/workflows/quarto-render.yml
name: Render and deploy Quarto files
on: 
  push:
  pull_request:

jobs:
  quarto-render-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: "Install Quarto and render"
      uses: pommevilla/quarto-render@main

    - name: "Deploy to gh-pages"
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/master'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./_site
```

The final results can be viewed [https://pommevilla.github.io/friendly-dollop/](here).

