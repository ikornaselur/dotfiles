#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'


if [ "$(ls -A .)" ]; then
  echo "Current directly is not empty"
  exit 1
fi

echo "Project name:"
read PROJECT_NAME
FOLDER_NAME=${PROJECT_NAME//-/_}

# Set up poetry
poetry init -n --author "Axel <dev@absalon.is>" --license MIT --name $PROJECT_NAME
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
  flake8-annotations \
  ipdb \
  pdbpp \
  pytest \
  pytest-clarity

# Create folder
echo -e "${GREEN}[+] Creating folders...${NC}"
mkdir -p tests/unit .hooks src/$FOLDER_NAME

echo -e "${GREEN}[+] Adding hello world...${NC}"
cat <<EOF >> src/$FOLDER_NAME/__init__.py
def hello(name: str) -> str:
    return f"Hello, {name}"
EOF
cat <<EOF >> tests/unit/test_$FOLDER_NAME.py
from $FOLDER_NAME import hello


def test_hello() -> None:
    assert hello("there") == "Hello, there"
EOF


# Add Makefile
echo -e "${GREEN}[+] Adding Makefile...${NC}"
cat <<EOF >> Makefile
mypy:
	@poetry run mypy src/$FOLDER_NAME/* tests/*

flake8:
	@poetry run flake8 src/$FOLDER_NAME/* tests/*

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
echo -e "${GREEN}[+] Adding pre-push hook...${NC}"
cat <<EOF >> .hooks/pre-push
#!/bin/bash
echo "Checking if code lints..."
xargs -P 2 -I {} sh -c 'eval "$1"' - {} <<'EOF'
make mypy
make flake8
EOF
chmod +x .hooks/pre-push

# Initi git repo
echo -e "${GREEN}[+] Initialising repo...${NC}"
git init

# Install hooks
echo -e "${GREEN}[+] Installing hook...${NC}"
make install_git_hooks

# Add .gitignore
echo -e "${GREEN}[+] Adding .gitignore...${NC}"
cat <<EOF >> .gitignore
*.egg-info
.venv
dist
EOF

# Final install the package for development
poetry install

echo -e "${GREEN}[+] Done!${NC}"
