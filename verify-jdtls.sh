#!/bin/bash

# Este script verifica e corrige a configuração do LSP para Java (JDTLS) no Neovim

# Defina cores para saída
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Verificando configuração do JDTLS para Neovim ===${NC}"

# Verificar se o Mason está instalado e o JDTLS está presente
if [ -d "$HOME/.local/share/nvim/mason/packages/jdtls" ]; then
    echo -e "${GREEN}✓ JDTLS está instalado pelo Mason${NC}"
else
    echo -e "${RED}✗ JDTLS não encontrado!${NC}"
    echo -e "${YELLOW}Instalando JDTLS via Mason...${NC}"
    nvim --headless -c "MasonInstall jdtls" -c "sleep 5000m" -c "qa"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Falha ao instalar JDTLS. Verifique se o Mason está configurado corretamente.${NC}"
        exit 1
    fi
fi

# Garantir que o nvim-jdtls está instalado
echo -e "${YELLOW}Verificando plugin nvim-jdtls...${NC}"
if grep -q "nvim-jdtls" "$HOME/.config/nvim/lua/plugins/lsp.lua"; then
    echo -e "${GREEN}✓ Plugin nvim-jdtls encontrado na configuração${NC}"
else
    echo -e "${YELLOW}Adicionando plugin nvim-jdtls à configuração...${NC}"
    # Criar backup
    cp "$HOME/.config/nvim/lua/plugins/lsp.lua" "$HOME/.config/nvim/lua/plugins/lsp.lua.bak"
    
    # Adicionar o plugin nvim-jdtls
    awk '/return \{/{print; getline; print; print "  {"; print "    \"mfussenegger/nvim-jdtls\","; print "    ft = { \"java\" },"; print "  },"; next}1' "$HOME/.config/nvim/lua/plugins/lsp.lua.bak" > "$HOME/.config/nvim/lua/plugins/lsp.lua"
    
    echo -e "${GREEN}✓ Plugin nvim-jdtls adicionado${NC}"
fi

# Verificar configuração do JDTLS
echo -e "${YELLOW}Verificando configuração do JDTLS...${NC}"
if [ -f "$HOME/.config/nvim/lua/configs/jdtls.lua" ]; then
    echo -e "${GREEN}✓ Arquivo de configuração do JDTLS encontrado${NC}"
    # Verificar se o arquivo tem conteúdo válido
    if grep -q "M.setup" "$HOME/.config/nvim/lua/configs/jdtls.lua"; then
        echo -e "${GREEN}✓ Configuração do JDTLS parece válida${NC}"
    else
        echo -e "${YELLOW}Configuração do JDTLS pode estar incompleta${NC}"
    fi
else
    echo -e "${RED}✗ Arquivo de configuração do JDTLS não encontrado!${NC}"
fi

# Verificar ftplugin para Java
echo -e "${YELLOW}Verificando configuração específica para Java...${NC}"
if [ -f "$HOME/.config/nvim/ftplugin/java.lua" ]; then
    echo -e "${GREEN}✓ Arquivo ftplugin para Java encontrado${NC}"
    # Verificar se o arquivo inicializa o JDTLS
    if grep -q "jdtls_config.setup" "$HOME/.config/nvim/ftplugin/java.lua"; then
        echo -e "${GREEN}✓ ftplugin para Java parece válido${NC}"
    else
        echo -e "${YELLOW}ftplugin para Java pode estar incompleto${NC}"
    fi
else
    echo -e "${RED}✗ ftplugin para Java não encontrado!${NC}"
fi

# Verificar configuração do LSP em lspconfig.lua
echo -e "${YELLOW}Verificando exclusão do jdtls da configuração global...${NC}"
if grep -q "-- Não incluir 'jdtls'" "$HOME/.config/nvim/lua/configs/lspconfig.lua"; then
    echo -e "${GREEN}✓ JDTLS corretamente excluído da configuração global${NC}"
else
    echo -e "${YELLOW}Configurando para excluir jdtls da configuração global...${NC}"
    cp "$HOME/.config/nvim/lua/configs/lspconfig.lua" "$HOME/.config/nvim/lua/configs/lspconfig.lua.bak"
    sed -i 's/local servers = {/local servers = { -- Não incluir '\''jdtls'\'' aqui, ele será configurado separadamente via nvim-jdtls/' "$HOME/.config/nvim/lua/configs/lspconfig.lua"
    echo -e "${GREEN}✓ JDTLS excluído da configuração global${NC}"
fi

echo -e "${BLUE}=== Verificação concluída ===${NC}"
echo -e "${YELLOW}Para aplicar as alterações, reinicie o Neovim${NC}"
echo -e "${YELLOW}Ao abrir um arquivo Java, o JDTLS deve ser iniciado automaticamente${NC}"
