require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def main
  get_transaction_data
  landing_page = login
  transfers_page = landing_page.link_with(text: 'Transfers & Payments').click
end

def get_transaction_data
  # Schwab transaction data not yet supported from Plaid
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

def user
  @user ||= Plaid.add_user('auth', ENV['SCHWAB_USERNAME'], ENV['SCHWAB_PASSWORD'], 'schwab')
end

main