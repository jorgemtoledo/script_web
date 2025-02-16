require 'selenium-webdriver'

# Configuração do WebDriver
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--start-maximized')
options.add_argument('--disable-notifications')
driver = Selenium::WebDriver.for :chrome, options: options

begin
  wait = Selenium::WebDriver::Wait.new(timeout: 30)

  # 1️⃣ Acessar a página de login
  driver.get("site")
  sleep 5

  # 2️⃣ Inserir e-mail
  email_field = wait.until { driver.find_element(:name, 'loginfmt') }
  email_field.send_keys('email', :enter)
  sleep 3

  # 3️⃣ Inserir senha
  password_field = wait.until { driver.find_element(:name, 'passwd') }
  password_field.send_keys('senha01', :enter)
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
  codigo_verificacao = "123"
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

  # 🔟 Clicar no botão para abrir o dropdown
  unidade_lov_button = wait.until { driver.find_element(:id, 'P9998_UNIDADE_lov_btn') }
  driver.execute_script("arguments[0].click();", unidade_lov_button)
  puts "✅ Seletor de unidade aberto!"

  # 🔟.1️⃣ Aguardar até que o dropdown apareça na tela
  sleep 2 # Tempo para o dropdown ser renderizado

  # 🔎 **Verifica se há um iframe e troca para ele**
  iframes = driver.find_elements(:tag_name, "iframe")
  if iframes.any?
    puts "🔄 Mudando para o iframe do dropdown..."
    driver.switch_to.frame(iframes.first)
  end

  # 🔎 **Procura pelo dropdown de diferentes formas**
  begin
    dropdown = wait.until { driver.find_element(:css, "ul.ui-menu[role='listbox']") }
    puts "✅ Dropdown (ul.ui-menu) encontrado!"
  rescue Selenium::WebDriver::Error::TimeoutError
    begin
      # dropdown = wait.until { driver.find_element(:css, "div.a-Dialog") }
      dropdown = wait.until { driver.find_element(css: "div.a-Dialog") }
      puts "✅ Dropdown (div.a-Dialog) encontrado!"
    rescue Selenium::WebDriver::Error::TimeoutError
      puts "❌ Nenhum dropdown encontrado! Capturando HTML da página..."
      puts driver.page_source # Para debug
      raise "Erro: O dropdown não apareceu."
    end
  end

  # 🔟.2️⃣ Selecionar a opção "Unidade"
  unidade_option = wait.until { driver.find_element(:xpath, "//li[contains(text(), 'Unidade')]") }
  driver.execute_script("arguments[0].click();", unidade_option)
  puts "✅ Unidade 'Unidade' selecionada!"
  sleep 3

  # 🔟.3️⃣ Redirecionamento
  puts "✅ Página redirecionada com sucesso!"
  puts "✅ URL após redirecionamento: #{driver.current_url}"

ensure
  sleep 5
  driver.quit
end
