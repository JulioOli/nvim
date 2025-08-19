#!/bin/bash

# Script para configurar o ambiente Java e reiniciar o LSP

# Cores para melhor visualização
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Configurando ambiente Java para o projeto ===${NC}"

# Variáveis do projeto
PROJECT_DIR="$HOME/Documents/2025_Ultimo_semestre/ES 2/projeto_observer_mvc"
SETTINGS_DIR="$PROJECT_DIR/.vscode"
JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# Verifica se o JAVA_HOME é válido
if [ -z "$JAVA_HOME" ]; then
    echo -e "${RED}✗ JAVA_HOME não encontrado! Verificando alternativas...${NC}"
    if [ -d "/usr/lib/jvm/default-java" ]; then
        JAVA_HOME="/usr/lib/jvm/default-java"
    elif [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
        JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
    else
        echo -e "${RED}✗ Não foi possível determinar o JAVA_HOME. Por favor, instale o JDK.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Usando JAVA_HOME=$JAVA_HOME${NC}"
fi

# Certifica que o diretório do projeto existe
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}✗ Diretório do projeto não encontrado: $PROJECT_DIR${NC}"
    exit 1
fi

# Certifica que o diretório bin existe
if [ ! -d "$PROJECT_DIR/bin" ]; then
    echo -e "${YELLOW}Criando diretório bin...${NC}"
    mkdir -p "$PROJECT_DIR/bin"
    echo -e "${GREEN}✓ Diretório bin criado${NC}"
else
    echo -e "${GREEN}✓ Diretório bin já existe${NC}"
fi

# Certifica que o diretório .vscode existe e tem o settings.json
if [ ! -d "$SETTINGS_DIR" ]; then
    echo -e "${YELLOW}Criando diretório .vscode...${NC}"
    mkdir -p "$SETTINGS_DIR"
    echo -e "${GREEN}✓ Diretório .vscode criado${NC}"
else
    echo -e "${GREEN}✓ Diretório .vscode já existe${NC}"
fi

# Cria o arquivo settings.json
echo -e "${YELLOW}Criando arquivo settings.json para configuração do Java...${NC}"
cat > "$SETTINGS_DIR/settings.json" << 'EOF'
{
    "java.project.sourcePaths": ["", "controller", "model", "view"],
    "java.project.outputPath": "bin",
    "java.format.settings.profile": "Eclipse",
    "java.completion.importOrder": [
        "java",
        "javax",
        "com",
        "org",
        "model",
        "view",
        "controller"
    ],
    "java.configuration.updateBuildConfiguration": "interactive"
}
EOF
echo -e "${GREEN}✓ Arquivo settings.json criado${NC}"

# Compila o projeto
echo -e "${YELLOW}Compilando o projeto...${NC}"
cd "$PROJECT_DIR"
javac -d bin controller/*.java model/*.java view/*.java
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Erro ao compilar o projeto${NC}"
else
    echo -e "${GREEN}✓ Projeto compilado com sucesso${NC}"
fi

echo -e "${BLUE}=== Configuração concluída ===${NC}"
echo -e "${YELLOW}Para aplicar as alterações:${NC}"
echo -e "1. Reinicie o Neovim"
echo -e "2. Abra um arquivo Java no projeto"
echo -e "3. O LSP deve ser iniciado automaticamente"
echo -e "${BLUE}Para compilar e executar o projeto:${NC}"
echo -e "- Use <leader>jca para compilar todo o projeto"
echo -e "- Use <leader>jra para executar a aplicação MonitorAcoes"
