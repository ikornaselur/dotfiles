#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}[+] Upgrading pyenv...${NC}"
brew upgrade pyenv

VERSION27=`pyenv install --list | grep -E "^\s+2.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION37=`pyenv install --list | grep -E "^\s+3.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION38=`pyenv install --list | grep -E "^\s+3.8.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION39=`pyenv install --list | grep -E "^\s+3.9.\d+$" | tail -1 | tr -d '[:space:]'`

VERSIONS="${VERSION38} ${VERSION27} ${VERSION39} ${VERSION37}"

echo -e "${GREEN}[+] Will install ${VERSIONS}${NC}"
echo -ne "${ORANGE}"
read -p "[?] Are you sure? (y/N) " -n 1 -r
echo -e "${NC}"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo -e "${GREEN}[+] Installing ${VERSION27} [1/4]...${NC}"
  pyenv install ${VERSION27}
  echo -e "${GREEN}[+] Installing ${VERSION37} [2/4]...${NC}"
  pyenv install ${VERSION37}
  echo -e "${GREEN}[+] Installing ${VERSION38} [3/4]...${NC}"
  pyenv install ${VERSION38}
  echo -e "${GREEN}[+] Installing ${VERSION39} [4/4]...${NC}"
  pyenv install ${VERSION39}
  echo -e "${GREEN}[+] Setting global versions to ${VERSIONS}...${NC}"
  pyenv global ${VERSIONS}

  echo -e "${GREEN}[+] Installing base pip requirements and tools...${NC}"
  pip install --upgrade pip
  pip install \
    pipx \
    poetry \
    pynvim \
    isort \
    flake8

  echo -e "${GREEN}[+] Installing more tools with pipx...${NC}"

  declare -a PipxTools=(
    "black"
    "mypy"
    "pgcli"
    "awscli"
    "ipython"
    "credstash"
    "sucket"
    "dict-typer"
    "pytype"
  )

  for val in ${PipxTools[@]}; do
    pipx uninstall $val
    pipx install -f $val
  done

  pipx uninstall kyber-k8s
  pipx install -f kyber-k8s==0.8.0rc2

  echo -e "${GREEN}[+] All done!${NC}"
else
  echo -e "${RED}[-] Aborting...${NC}"
fi
