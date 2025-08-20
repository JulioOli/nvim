#!/bin/bash
cd ~/.config/nvim
# Instala clangd via Mason
nvim --headless -c "MasonInstall clangd" -c "sleep 3000" -c "qa!"
echo "Instalação do clangd concluída!"
