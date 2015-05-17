require 'rubygems'
require 'mechanize'

agent = Mechanize.new

page = agent.get('https://schwab.com/')
sign_on_form = page.form('SignonForm')
sign_on_form.SignonAccountNumber = ENV['SCHWAB_USERNAME']
sign_on_form.SignonPassword = ENV['SCHWAB_PASSWORD']

# google_page = agent.get('http://google.com/')
# pp google_page