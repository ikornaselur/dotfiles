#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}[+] Upgrading pyenv...${NC}"
brew upgrade pyenv

VERSION27=`pyenv install --list | grep -E "^\s+2.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION35=`pyenv install --list | grep -E "^\s+3.5.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION36=`pyenv install --list | grep -E "^\s+3.6.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION37=`pyenv install --list | grep -E "^\s+3.7.\d+$" | tail -1 | tr -d '[:space:]'`
VERSION38=`pyenv install --list | grep -E "^\s+3.8.\d+$" | tail -1 | tr -d '[:space:]'`

VERSIONS="${VERSION38} ${VERSION37} ${VERSION27} ${VERSION36} ${VERSION35}"

echo -e "${GREEN}[+] Will install ${VERSIONS}${NC}"
echo -ne "${ORANGE}"
read -p "[?] Are you sure? (y/N) " -n 1 -r
echo -e "${NC}"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo -e "${GREEN}[+] Installing ${VERSION27} [1/5]...${NC}"
  pyenv install ${VERSION27}
  echo -e "${GREEN}[+] Installing ${VERSION35} [2/5]...${NC}"
  pyenv install ${VERSION35}
  echo -e "${GREEN}[+] Installing ${VERSION36} [3/5]...${NC}"
  pyenv install ${VERSION36}
  echo -e "${GREEN}[+] Installing ${VERSION37} [4/5]...${NC}"
  pyenv install ${VERSION37}
  echo -e "${GREEN}[+] Installing ${VERSION38} [5/5]...${NC}"
  pyenv install ${VERSION38}
  echo -e "${GREEN}[+] Setting global versions to ${VERSIONS}...${NC}"
  pyenv global ${VERSIONS}

  echo -e "${GREEN}[+] Installing base pip requirements...${NC}"
  pip install --upgrade pip
  pip install \
    pipx \
    poetry \
    pynvim

  echo -e "${GREEN}[+] Installing tools with pipx...${NC}"
  pipx uninstall isort
  pipx install -f isort

  pipx uninstall flake8
  pipx install -f flake8

  pipx uninstall black
  pipx install -f black

  pipx uninstall mypy
  pipx install -f mypy

  pipx uninstall monkeytype
  pipx install -f monkeytype

  pipx uninstall pgcli
  pipx install -f pgcli

  pipx uninstall awscli
  pipx install -f awscli

  pipx uninstall ipython
  pipx install -f ipython

  pipx uninstall credstash
  pipx install -f credstash

  pipx uninstall kyber-k8s
  pipx install -f kyber-k8s==0.8.0rc2

  pipx uninstall sucket
  pipx install -f sucket

  pipx uninstall dict-typer
  pipx install -f dict-typer

  echo -e "${GREEN}[+] All done!${NC}"
else
  echo -e "${RED}[-] Aborting...${NC}"
fi
