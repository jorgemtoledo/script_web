require 'selenium-webdriver'

# Configuração do WebDriver
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--start-maximized')
options.add_argument('--disable-notifications')
driver = Selenium::WebDriver.for :chrome, options: options

begin
  wait = Selenium::WebDriver::Wait.new(timeout: 60)

  # 1️⃣ Acessar a página de login
  driver.get("site")
  sleep 5

  # 2️⃣ Inserir e-mail
  email_field = wait.until { driver.find_element(:name, 'loginfmt') }
  email_field.send_keys('email', :enter)
  sleep 3

  # 3️⃣ Inserir senha
  password_field = wait.until { driver.find_element(:name, 'passwd') }
  password_field.send_keys('password', :enter)
  sleep 3

  # 4️⃣ Clicar na opção "Não consigo usar meu aplicativo Microsoft Authenticator agora"
  alternativa_link = wait.until { driver.find_element(:xpath, "//a[contains(text(), 'Não consigo usar meu aplicativo Microsoft Authenticator agora')]") }
  alternativa_link.click
  sleep 3

  # 5️⃣ Clicar na opção "Usar um código de verificação"
  codigo_verificacao_link = wait.until { driver.find_element(:xpath, "//div[contains(@class, 'table-cell') and contains(., 'Usar um código de verificação')]") }
  driver.execute_script("arguments[0].click();", codigo_verificacao_link)
  sleep 3

  # 6️⃣ Inserir o código de verificação
  codigo_verificacao = "215785"
  codigo_field = wait.until { driver.find_element(:id, 'idTxtBx_SAOTCC_OTC') }
  codigo_field.send_keys(codigo_verificacao)
  sleep 2

  # 7️⃣ Clicar no botão "Verificar"
  botao_verificar = wait.until { driver.find_element(:id, 'idSubmit_SAOTCC_Continue') }
  driver.execute_script("arguments[0].click();", botao_verificar)
  sleep 4

  # 8️⃣ Clicar no botão "Sim"
  botao_sim = wait.until { driver.find_element(:id, 'idSIButton9') }
  driver.execute_script("arguments[0].click();", botao_sim)
  sleep 5

  # 9️⃣ Capturar ID da sessão
  session_id = driver.current_url.split('session=')[1] rescue "ID não encontrado"
  puts "✅ ID da sessão: #{session_id}"

  # 🔟 Inserir valor no input manualmente
  unidade_input = wait.until { driver.find_element(:id, 'P9998_UNIDADE') }
  driver.execute_script("arguments[0].removeAttribute('readonly');", unidade_input)
  sleep 1
  unidade_input.clear
  sleep 1
  unidade_input.send_keys("Barra do Garças")
  sleep 2

  # 1️⃣1️⃣ Selecionar unidade com data-id="18"
  item_dropdown = wait.until { driver.find_element(:xpath, "//li[@data-id='18']") }
  driver.execute_script("arguments[0].click();", item_dropdown)
  sleep 2

  # 1️⃣2️⃣ Clicar no botão de navegação
  botao_nav_control = wait.until { driver.find_element(:id, 't_Button_navControl') }
  driver.execute_script("arguments[0].click();", botao_nav_control)
  sleep 2

  # 1️⃣3️⃣ Selecionar "Home"
  home_item = wait.until { driver.find_element(:xpath, "//span[text()='Home']") }
  driver.execute_script("arguments[0].click();", home_item)
  sleep 2

  # 1️⃣4️⃣ Clicar em "Consulta Cliente"
  consulta_cliente = wait.until { driver.find_element(:xpath, "//div[@class='a-TreeView-content']/a[contains(text(), 'Consulta Cliente')]") }
  driver.execute_script("arguments[0].click();", consulta_cliente)
  sleep 5

  # 1️⃣5️⃣ Inserir número de ligação
  num_ligacao_field = wait.until { driver.find_element(:id, 'P36_NUM_LIGACAO_PF') }
  num_ligacao_field.send_keys('403412')
  sleep 2

  # 1️⃣6️⃣ Clicar no botão "Pesquisar"
  botao_pesquisar = wait.until { driver.find_element(:id, 'B119727038853751511') }
  driver.execute_script("arguments[0].click();", botao_pesquisar)
  sleep 5

  # 1️⃣7️⃣ Clicar no primeiro resultado da pesquisa
  primeiro_resultado = wait.until { driver.find_element(:xpath, "//td[@headers='LINK']/a") }
  driver.execute_script("arguments[0].click();", primeiro_resultado)
  sleep 5

  # 1️⃣8️⃣ Clicar em "Consulta Completa"
  consulta_completa = wait.until { driver.find_element(:xpath, "//a[contains(@class, 'a-CardView-fullLink') and span[text()='Consulta Completa']]") }
  driver.execute_script("arguments[0].click();", consulta_completa)
  sleep 5

  # 1️⃣9️⃣ Clicar no botão "Consulta Contrato"
  botao_consulta_contrato = wait.until { driver.find_element(:id, 'B62501531920797503') }
  driver.execute_script("arguments[0].click();", botao_consulta_contrato)
  sleep 5

  # 🔟 Confirmar redirecionamento (sem a etapa do contrato 26580)
  puts "✅ Processo finalizado com sucesso!"
  puts "✅ URL após redirecionamento: #{driver.current_url}"

  sleep 10

ensure
  driver.quit
end
