#!/bin/bash

# Verifica se o Mason está instalado
if [ ! -d "$HOME/.local/share/nvim/mason" ]; then
  echo "Mason não está instalado. Execute o Neovim e use :Mason para instalar."
  exit 1
fi

# Remove o servidor antigo e instala o novo
echo "Removendo o servidor antigo tsserver..."
nvim --headless -c "MasonUninstall typescript-language-server" -c q

echo "Instalando o novo servidor ts_ls..."
nvim --headless -c "MasonInstall typescript-language-server@latest" -c q

echo "Atualizando os servidores LSP..."
nvim --headless -c "MasonUpdate" -c q

echo "Configuração do TypeScript concluída. Por favor reinicie o Neovim."
