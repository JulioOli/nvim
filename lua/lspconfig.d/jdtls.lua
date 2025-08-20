-- Configuração específica para JDTLS no formato compatível com lspconfig
-- Este arquivo NÃO configura o JDTLS diretamente, apenas impede que o lspconfig tente configurá-lo
-- A configuração real é feita em configs/jdtls.lua

-- Esta função vazia informa ao lspconfig que não deve tentar configurar o JDTLS
return function(lspconfig, config)
  -- Não fazemos nada, deixando a configuração para o nvim-jdtls
  return false
end
