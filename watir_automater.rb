require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def main
  login
  transfer_amount = calculate_transfer_amount
  # transfer_funds
  
  browser.close
rescue => ex
  browser.close
  puts ex.inspect
end

def login
  browser.goto('https://schwab.com/')
  browser.text_field(:name, 'SignonAccountNumber').set(ENV['SCHWAB_USERNAME'])
  browser.text_field(:name, 'SignonPassword').set(ENV['SCHWAB_PASSWORD'])
  browser.form(:name, 'SignonForm').submit
end

def calculate_transfer_amount
  transactions = get_transaction_data
# `transactions` returns an array of hashes - [{ deposit_date => deposit_amount }]

  # Calculate amounts of transactions to be transferred
  # Need to store dates of last transactions transferred and exclude those amounts
binding.pry
end

def get_transaction_data
  # Search for transactions matching criteria, and return the dates and amounts
  checking_account_link = browser.links.select{|link| link.text.include? 'Checking'}.first
  checking_account_link.click
  deposits = browser.trs.select{|tr| tr.text.include?('TECH 2000')}
  deposit_dates_and_amounts = deposits.collect do |deposit|
    { deposit.td(index: 0).text => deposit.td(index: 5).text }
  end
end

def transfer_funds
  browser.link(:text, 'Transfers & Payments').click
  from_list_id = "#{prefix}selFromAccount"
  from_account_dropdown = browser.select_list(id: from_list_id)
  from_account = from_account_dropdown.options.select{|option| option.value.upcase.include? 'CHECKING'}.first.value
  from_account_dropdown.option(value: from_account).select
  to_list_id = "#{prefix}selToAccount"
  to_account_dropdown = browser.select_list(id: to_list_id)
  to_account = from_account_dropdown.options.select{|option| option.value.upcase.include? 'SAVING'}.first.value
  to_account_dropdown.option(value: to_account).select
  amount_id = "#{prefix}txtTransToAmount"
  browser.text_field(:id, amount_id).set(transfer_amount)
  browser.link(:text, 'Continue').click
  browser.link(:id, "#{prefix}btnTransSubmit").click
end

def prefix
  schwab_field_prefix
end

def schwab_field_prefix
  'ctl00_contentLTPlaceHolder_ucOnlineTransfers_onlineTransfers_'
end

def browser
  @browser ||= Watir::Browser.new
end

main