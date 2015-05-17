require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def main
  landing_page = login
  transfers_page = landing_page.link_with(text: 'Transfers & Payments').click
end

def login  
  login_page = agent.get('https://schwab.com/')
  sign_on_form = login_page.form('SignonForm')
  sign_on_form.SignonAccountNumber = ENV['SCHWAB_USERNAME']
  sign_on_form.SignonPassword = ENV['SCHWAB_PASSWORD']
  agent.submit(sign_on_form, sign_on_form.buttons.first)
end

def agent
  @agent ||= Mechanize.new
end

main


