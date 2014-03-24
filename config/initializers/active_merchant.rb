require 'active_merchant'

ActiveMerchant::Billing::Base.mode = :test

GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  login:     ENV['PAYPAL_LOGIN'],
  password:  ENV['PAYPAL_PWD'],
  signature: ENV['PAYPAL_SIGNATURE']
)
