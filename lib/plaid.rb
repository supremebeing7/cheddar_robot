Plaid.config do |p|
  p.customer_id = ENV['PLAID_ID']
  p.secret = ENV['PLAID_SECRET']
  p.environment_location = 'https://tartan.plaid.com'
end