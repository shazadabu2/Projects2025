# EDA

[![Release](https://img.shields.io/github/v/release/shazadabu2/EDA)](https://img.shields.io/github/v/release/shazadabu2/EDA)
[![Build status](https://img.shields.io/github/actions/workflow/status/shazadabu2/EDA/main.yml?branch=main)](https://github.com/shazadabu2/EDA/actions/workflows/main.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/shazadabu2/EDA/branch/main/graph/badge.svg)](https://codecov.io/gh/shazadabu2/EDA)
[![Commit activity](https://img.shields.io/github/commit-activity/m/shazadabu2/EDA)](https://img.shields.io/github/commit-activity/m/shazadabu2/EDA)
[![License](https://img.shields.io/github/license/shazadabu2/EDA)](https://img.shields.io/github/license/shazadabu2/EDA)

This is a template repository for Python projects that use Poetry for their dependency management.

- **Github repository**: <https://github.com/shazadabu2/EDA/>
- **Documentation** <https://shazadabu2.github.io/EDA/>

## Getting started with your project

First, create a repository on GitHub with the same name as this project, and then run the following commands:

```bash
git init -b main
git add .
git commit -m "init commit"
git remote add origin git@github.com:shazadabu2/EDA.git
git push -u origin main
```

Finally, install the environment and the pre-commit hooks with

```bash
make install
```

You are now ready to start development on your project!
The CI/CD pipeline will be triggered when you open a pull request, merge to main, or when you create a new release.

To finalize the set-up for publishing to PyPi or Artifactory, see [here](https://fpgmaas.github.io/cookiecutter-poetry/features/publishing/#set-up-for-pypi).
For activating the automatic documentation with MkDocs, see [here](https://fpgmaas.github.io/cookiecutter-poetry/features/mkdocs/#enabling-the-documentation-on-github).
To enable the code coverage reports, see [here](https://fpgmaas.github.io/cookiecutter-poetry/features/codecov/).

## Releasing a new version



---

Repository initiated with [fpgmaas/cookiecutter-poetry](https://github.com/fpgmaas/cookiecutter-poetry).
