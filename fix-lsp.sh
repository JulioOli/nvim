#!/bin/bash

# Este script resolve os problemas de nomeação entre Mason e LSPConfig
echo "Corrigindo configuração de LSP para o Neovim..."

# Verificando pacotes instalados
echo "Verificando pacotes instalados via Mason..."
ls -la ~/.local/share/nvim/mason/packages/

# Reinstalando o TypeScript Language Server
echo "Reinstalando o TypeScript Language Server..."
nvim --headless -c "MasonInstall typescript-language-server" -c q

echo "Configuração atualizada. Por favor reinicie o Neovim."
