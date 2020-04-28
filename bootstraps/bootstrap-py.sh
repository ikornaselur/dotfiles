#!/bin/bash

# Set up poetry
poetry init
poetry add --dev \
  isort \
  black \
  mypy \
  flake8 \
  flake8-builtins \
  flake8-isort \
  flake8-bugbear \
  flake8-black \
  flake8-comprehensions \
  ipdb \
  pdbpp \
  pytest \
  pytest-clarity

# Create folder
echo "Creating folders..."
mkdir -p tests/unit .hooks

# Add Makefile
echo "Adding Makefile..."
cat <<EOF >> Makefile
mypy:
	@poetry run mypy dict_typer tests/*

flake8:
	@poetry run flake8 dict_typer tests/*

lint: mypy flake8

test: unit_test

unit_test:
	@poetry run pytest tests/unit -xvvs

shell:
	@poetry run ipython

install_git_hooks:
	@ln -s `pwd`/.hooks/pre-push .git/hooks/pre-push
EOF

# Add hook
echo "Adding pre-push hook..."
cat <<EOF >> .hooks/pre-push
#!/bin/bash
echo "Checking if code lints..."
make lint
echo ""
EOF

# Initi git repo
echo "Initialising repo"
git init

# Install hooks
echo "Installing hook"
make install_git_hooks

echo "Done!"
