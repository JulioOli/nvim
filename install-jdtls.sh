#!/bin/bash

# Verifica se o Mason está instalado
if [ ! -d "$HOME/.local/share/nvim/mason" ]; then
  echo "Mason não está instalado. Execute o Neovim e use :Mason para instalar."
  exit 1
fi

# Instala o jdtls via Mason
nvim --headless -c "MasonInstall jdtls" -c q

# Verifica se a instalação foi bem-sucedida
if [ -f "$HOME/.local/share/nvim/mason/packages/jdtls/bin/jdtls" ]; then
  echo "jdtls instalado com sucesso!"
else
  echo "Falha ao instalar jdtls. Verifique os logs do Mason."
  exit 1
fi

echo "Configuração do LSP para Java concluída."
