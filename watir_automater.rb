require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def main
  login
  transfer_amount = calculate_transfer_amount
  transfer_funds
  
binding.pry

  browser.close
end

def login
  browser.goto('https://schwab.com/')
  browser.text_field(:name, 'SignonAccountNumber').set(ENV['SCHWAB_USERNAME'])
  browser.text_field(:name, 'SignonPassword').set(ENV['SCHWAB_PASSWORD'])
  browser.form(:name, 'SignonForm').submit
end

def calculate_transfer_amount
  transactions = get_transaction_data
  # Calculate amounts of transactions to be transferred
end

def get_transaction_data
  # Here is where we inspect the transactions, search for transactions matching criteria, and return the amounts
end

def transfer_funds
# Eventually should be dynamically created based on transaction data
  transfer_amount = 0


  browser.link(:text, 'Transfers & Payments').click
  from_list_id = "#{prefix}selFromAccount"
  from_account_dropdown = browser.select_list(id: from_list_id)
# This line takes an unreasonable amount of time to run... figure out a faster way to get this
# Tried `from_account_dropdown.option(text: 'checking').select` but didn't work
  from_account = from_account_dropdown.options.select{|option| option.value.upcase.include? 'CHECKING'}.first.value
  from_account_dropdown.option(value: from_account).select
  to_list_id = "#{prefix}selToAccount"
  to_account_dropdown = browser.select_list(id: to_list_id)
  to_account = from_account_dropdown.options.select{|option| option.value.upcase.include? 'SAVING'}.first.value
  to_account_dropdown.option(value: to_account).select
  amount_name = "#{prefix}txtTransToAmount"
  browser.text_field(:name, amount_name).set(transfer_amount)
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