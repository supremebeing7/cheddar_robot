require 'rubygems'
require 'mechanize'
require 'pry'

agent = Mechanize.new

login_page = agent.get('https://schwab.com/')
sign_on_form = login_page.form('SignonForm')
sign_on_form.SignonAccountNumber = ENV['SCHWAB_USERNAME']
sign_on_form.SignonPassword = ENV['SCHWAB_PASSWORD']

landing_page = agent.submit(sign_on_form, sign_on_form.buttons.first)

transfers_page = landing_page.link_with(text: 'Transfers & Payments').click


