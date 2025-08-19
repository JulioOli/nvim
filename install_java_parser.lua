-- Script para instalar o parser do Java
local ts_parsers = require('nvim-treesitter.parsers')
local ts_install = require('nvim-treesitter.install')

-- Verifica se o parser do Java já está instalado
local java_installed = ts_parsers.has_parser('java')

if not java_installed then
  print("Instalando o parser do Java...")
  ts_install.commands.TSInstall({'java'})
  print("Parser do Java instalado com sucesso!")
else
  print("O parser do Java já está instalado!")
end

vim.cmd("quit")
