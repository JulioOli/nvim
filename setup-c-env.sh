#!/bin/bash

# Cria o arquivo .clangd no diretório home do usuário
cat > ~/.clangd << EOF
CompileFlags:
  Add: [-Wall, -Wextra, -std=c11]
  
Diagnostics:
  ClangTidy:
    Add: [performance-*, modernize-*, readability-*]
    
InlayHints:
  Enabled: true
  ParameterNames: true
  DeducedTypes: true
  
Hover:
  ShowAKA: true
EOF

echo "Arquivo de configuração do clangd criado em ~/.clangd"

# Cria um arquivo compile_commands.json básico no diretório atual
cat > compile_commands.json << EOF
[
  {
    "directory": "$(pwd)",
    "command": "clang -Wall -Wextra -std=c11 -c main.c",
    "file": "main.c"
  }
]
EOF

echo "Arquivo compile_commands.json básico criado no diretório atual"
echo "Configuração para C concluída!"
