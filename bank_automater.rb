require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def main
  get_transaction_data
  landing_page = login

  # Complete transfer form
  transfers_page = landing_page.link_with(text: 'Transfers & Payments').click
  transfer_form = transfers_page.form('aspnetForm')
  transfer_amount = 1
  transfer_date = Date.today.strftime('%m/%d/%Y')
  transfer_frequency = 'ONETIME'
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$txtTransToAmount').value = transfer_amount
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$txtTransDate').value = transfer_date
  select_from_account_options = transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$selFromAccount').options
  checking_account, checking_account_index = select_from_account_options.each_with_index.map{|account, index| [account, index] if account.value.downcase.include?('checking')}.compact.first
  checking_account.select
  select_to_account_options = transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$selToAccount').options
  saving_account, saving_account_index = select_to_account_options.each_with_index.map{|account, index| [account, index] if account.value.downcase.include?('saving')}.compact.first
  saving_account.select

  # Fill out hidden form fields
  checking_account_attributes = checking_account.value.split('|||')
  checking_account_number = checking_account_attributes[0]
  checking_account_type = checking_account_attributes[1]
  checking_account_nick = checking_account_attributes[3]
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFrm').value = checking_account_number
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFrmExtrAcct').value = checking_account_number
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFrmAcctType').value = checking_account_type
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFrmNick').value = checking_account_nick
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFrmIndex').value = checking_account_index
  saving_account_attributes = saving_account.value.split('|||')
  saving_account_number = saving_account_attributes[0]
  saving_account_type = saving_account_attributes[1]
  saving_account_nick = saving_account_attributes[3]
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnTo').value = saving_account_number
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnToExtrAcct').value = saving_account_number
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnToAcctType').value = saving_account_type
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnToNick').value = saving_account_nick
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnToIndex').value = saving_account_index
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnAmt').value = transfer_amount
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnDate').value = transfer_date
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFreq').value = transfer_frequency
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnFreqIndex').value = 0
  transfer_form.field_with(name: 'ctl00$contentLTPlaceHolder$ucOnlineTransfers$onlineTransfers$hdnIsBank').value = true
  # There is still something missing causing this not to submit properly. It appears I have all of the hidden inputs
  # filled out correctly, but it is still not submitting. There is a lot of JS on the page,
  # it's possible that the JS is evaluating some of the input values and filling something else in.

  agent.submit(transfer_form)
end

def get_transaction_data
  # Schwab transaction data not yet supported from Plaid
  # Here is where we inspect the transactions, search for transactions matching criteria, and get the amounts
end

def login
  login_page = agent.get('https://schwab.com/')
  sign_on_form = login_page.form('SignonForm')
  sign_on_form.SignonAccountNumber = ENV['SCHWAB_USERNAME']
  sign_on_form.SignonPassword = ENV['SCHWAB_PASSWORD']
  agent.submit(sign_on_form)
end

def agent
  @agent ||= Mechanize.new
end

def user
  @user ||= Plaid.add_user('auth', ENV['SCHWAB_USERNAME'], ENV['SCHWAB_PASSWORD'], 'schwab')
end

main