#!/bin/bash

# Script para corrigir problemas de LSP em projetos Java com estrutura plana

PROJECT_DIR="$HOME/Documents/2025_Ultimo_semestre/ES 2/projeto_observer_mvc"

# Navega para o diretório do projeto
cd "$PROJECT_DIR" || { echo "Erro: Diretório do projeto não encontrado"; exit 1; }

# Cria o diretório .vscode se não existir
mkdir -p .vscode

# Cria ou sobrescreve o arquivo settings.json
cat > .vscode/settings.json << 'EOF'
{
    "java.project.sourcePaths": ["", "controller", "model", "view"],
    "java.project.outputPath": "bin",
    "java.project.referencedLibraries": [],
    "java.format.settings.url": "eclipse-formatter.xml",
    "java.format.settings.profile": "Eclipse [built-in]",
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

echo "Arquivo settings.json criado com sucesso."

# Compila o projeto para verificar
javac -d bin controller/*.java model/*.java view/*.java
if [ $? -eq 0 ]; then
    echo "Projeto compilado com sucesso."
else
    echo "Erro durante a compilação do projeto."
    exit 1
fi

echo "Configuração concluída. Reinicie o Neovim para aplicar as alterações."
