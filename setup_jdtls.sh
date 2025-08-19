#!/bin/bash

# Script para instalar e configurar corretamente o jdtls

echo "=== Iniciando instalação do jdtls para Neovim ==="

# Verificar se o Java está instalado
if ! command -v java &> /dev/null; then
    echo "Java não está instalado. Por favor, instale o Java primeiro."
    exit 1
fi

echo "✓ Java encontrado: $(java -version 2>&1 | head -n 1)"

# Criar diretório para o jdtls se não existir
JDTLS_HOME="$HOME/.local/share/nvim/mason/packages/jdtls"
mkdir -p "$JDTLS_HOME"

echo "=== Instalando jdtls usando Mason ==="
nvim --headless -c "MasonInstall jdtls" -c "qa"

# Verificar se a instalação foi bem-sucedida
if [ -d "$JDTLS_HOME/bin" ]; then
    echo "✓ jdtls instalado com sucesso em: $JDTLS_HOME"
else
    echo "✗ Falha ao instalar jdtls. Verifique os logs do Mason."
    exit 1
fi

# Adicionar ao PATH se ainda não estiver
if ! echo "$PATH" | grep -q "$JDTLS_HOME/bin"; then
    echo "export PATH=\"\$PATH:$JDTLS_HOME/bin\"" >> ~/.bashrc
    echo "export PATH=\"\$PATH:$JDTLS_HOME/bin\"" >> ~/.zshrc
    echo "✓ jdtls adicionado ao PATH nos arquivos .bashrc e .zshrc"
fi

echo "=== Instalação completa ==="
echo "Por favor, reinicie seu terminal ou execute 'source ~/.bashrc' (ou source ~/.zshrc)"
echo "Em seguida, reinicie o Neovim e abra um arquivo .java para testar o LSP"
