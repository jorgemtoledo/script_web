require 'selenium-webdriver'
require 'dotenv'
Dotenv.load

# Solicitar código de verificação no início
print "Digite o código de verificação: "
codigo_verificacao = gets.chomp

download = {
  prompt_for_download: false, 
  default_directory: ENV['FILE_DIRECTORY']
}

plugins = {
  always_open_pdf_externally: true,
  plugins_disabled: ["Chrome PDF Viewer"]
}

# Configuração do WebDriver
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--start-maximized')
options.add_argument('--disable-notifications')
options.add_preference(:download, download)
options.add_preference(:plugins, plugins)
driver = Selenium::WebDriver.for :chrome, options: options

errors = [Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::ElementNotInteractableError]

begin
  wait = Selenium::WebDriver::Wait.new(timeout: 60, interval: 0.3, ignore: errors)

  # Acessar a página de login
  driver.get(ENV['URL'])
  sleep 3

  # Inserir e-mail
  email_field = wait.until { driver.find_element(:name, 'loginfmt') }
  email_field.send_keys(ENV['EMAIL'], :enter)
  sleep 2

  # Inserir senha
  password_field = wait.until { driver.find_element(:name, 'passwd') }
  password_field.send_keys(ENV['PASS'], :enter)
  sleep 2

  # Clicar na opção "Não consigo usar meu aplicativo Microsoft Authenticator agora"
  el = wait.until { driver.find_element(:xpath, "//a[contains(text(), 'Não consigo usar meu aplicativo Microsoft Authenticator agora')]") }
  el.click
  sleep 2

  # Clicar na opção "Usar um código de verificação"
  el = wait.until { driver.find_element(:xpath, "//div[contains(@class, 'table-cell') and contains(., 'Usar um código de verificação')]") }
  el.click
  sleep 2

  # Inserir o código de verificação
  el = wait.until { driver.find_element(:id, 'idTxtBx_SAOTCC_OTC') }
  el.send_keys(codigo_verificacao)
  sleep 2

  # Clicar no botão "Verificar"
  el = wait.until { driver.find_element(:id, 'idSubmit_SAOTCC_Continue') }
  el.click
  sleep 3

  # Clicar no botão "Sim"
  el = wait.until { driver.find_element(:id, 'idSIButton9') }
  el.click
  sleep 4

  # Capturar ID da sessão
  session_id = driver.current_url.split('session=')[1] rescue "ID não encontrado"
  puts "✅ ID da sessão: #{session_id}"

  # Inserir valor no input manualmente
  el = wait.until { driver.find_element(:id, 'P9998_UNIDADE') }
  driver.execute_script("arguments[0].removeAttribute('readonly');", el)
  sleep 1
  el.clear
  sleep 1
  el.send_keys(ENV['LOCATION'])
  sleep 2

  # Selecionar unidade com data-id="18"
  el = wait.until { driver.find_element(:xpath, "//li[@data-id='18']") }
  el.click
  sleep 2

  # Clicar no botão de navegação
  el = wait.until { driver.find_element(:id, 't_Button_navControl') }
  el.click
  sleep 2

  # Selecionar "Home"
  el = wait.until { driver.find_element(:xpath, "//span[text()='Home']") }
  el.click
  sleep 2

  # Clicar em "Consulta Cliente"
  el = wait.until { driver.find_element(:xpath, "//div[@class='a-TreeView-content']/a[contains(text(), 'Consulta Cliente')]") }
  el.click
  sleep 5

  # Inserir número de ligação
  el = wait.until { driver.find_element(:id, 'P36_NUM_LIGACAO_PF') }
  el.send_keys(ENV['REGISTRATION'])
  sleep 2

  # Clicar no botão "Pesquisar"
  el = wait.until { driver.find_element(:id, 'B119727038853751511') }
  el.click
  sleep 5

  # Clicar no primeiro resultado da pesquisa
  el = wait.until { driver.find_element(:xpath, "//td[@headers='LINK']/a") }
  el.click
  sleep 5

  # Clicar em "Consulta Completa"
  el = wait.until { driver.find_element(:xpath, "//a[contains(@class, 'a-CardView-fullLink') and span[text()='Consulta Completa']]") }
  el.click
  sleep 5


  # Clicar no botão "Consulta Contrato"
  el = wait.until { driver.find_element(:id, 'B62501531920797503') }
  el.click
  sleep 5

  # iframe Contratos
  iframe = wait.until { driver.find_element(:xpath, "//iframe[contains(@title, 'Contratos')]") }
  sleep 3

  # entrar no frame
  driver.switch_to.frame iframe
  sleep 2

  # Clicar no contrato
  el = wait.until { driver.find_element(:xpath, "//td[contains(@class, 'u-tC') and text()='#{ENV['CONTRACT']}']/parent::tr/td[2]/a") }
  el.click
  sleep 3

  # sair do frame
  driver.switch_to.default_content
  sleep 2


  # Clicar em Lancamentos
  el = wait.until { driver.find_element(:xpath, "//a[contains(@class, 't-Card-wrap') and div/h3[text()='Lançamentos']]") }
  el.click
  sleep 5

  # desmarcar "Isentos"
  el = wait.until { driver.find_element(:id, 'P454_ISENTOS') }
  driver.execute_script("arguments[0].click();", el)
  sleep 2

  # selecionar todos
  el = wait.until { driver.find_element(:name, 'SELECT_ALL') }
  el.click
  sleep 5

  # clicar em guia
  el = wait.until { driver.find_element(:id, 'B68719954376298593') }
  el.click
  sleep 5


  # janela 'Retirar Acréscimos'
  iframe = wait.until { driver.find_element(:xpath, "//iframe[contains(@title, 'Retirar Acréscimos')]") }
  sleep 3

  driver.switch_to.frame iframe

  # bt sim
  el = wait.until { driver.find_element(:id, 'B71349524202069051') }
  el.click
  sleep 5

  # bt imprimir
  el = wait.until { driver.find_element(:id, 'B71314885102927245') }
  el.click
  sleep 5

  # sair do frame
  driver.switch_to.default_content


  # 🔟 Confirmar redirecionamento (sem a etapa do contrato 26580)
  puts "✅ Processo finalizado com sucesso!"
  puts "✅ URL após redirecionamento: #{driver.current_url}"

  sleep 10

ensure
  driver.quit
end