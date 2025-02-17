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
  codigo_verificacao = "123456"
  codigo_field = wait.until { driver.find_element(:id, 'idTxtBx_SAOTCC_OTC') }
  codigo_field.send_keys(codigo_verificacao)
  sleep 2

  # 7️⃣ Clicar no botão "Verificar"
  botao_verificar = wait.until { driver.find_element(:id, 'idSubmit_SAOTCC_Continue') }
  driver.execute_script("arguments[0].click();", botao_verificar)
  puts "✅ Botão 'Verificar' clicado com sucesso!"
  sleep 4

  # 8️⃣ Clicar no botão "Sim"
  botao_sim = wait.until { driver.find_element(:id, 'idSIButton9') }
  driver.execute_script("arguments[0].click();", botao_sim)
  puts "✅ Botão 'Sim' clicado com sucesso!"
  sleep 5

  # 9️⃣ Capturar ID da sessão
  session_id = driver.current_url.split('session=')[1] rescue "ID não encontrado"
  puts "✅ ID da sessão: #{session_id}"

  # 🔟 Inserir valor no input manualmente
  unidade_input = wait.until { driver.find_element(:id, 'P9998_UNIDADE') }

  # Remove atributo readonly via JavaScript
  driver.execute_script("arguments[0].removeAttribute('readonly');", unidade_input)
  sleep 1

  # Limpar o campo antes de inserir o texto
  unidade_input.clear
  sleep 1

  # Inserir "Buscar Unidade"
  unidade_input.send_keys("Buscar Unidade")
  sleep 2

  # 1️⃣1️⃣ Clicar diretamente no item com data-id="18"
  puts "✅ Tentando clicar no item com data-id='18'..."
  item_dropdown = wait.until { driver.find_element(:xpath, "//li[@data-id='18']") }
  driver.execute_script("arguments[0].click();", item_dropdown)
  sleep 2

  # 🔟 Confirmar redirecionamento
  puts "✅ Página redirecionada com sucesso!"
  puts "✅ URL após redirecionamento: #{driver.current_url}"

  # Pausar o script por 20 segundos antes de fechar a página
  sleep 20  # Aguarda 20 segundos para que você veja a página de redirecionamento

ensure
  sleep 5
  driver.quit
end
