require 'active_merchant'

ActiveMerchant::Billing::Base.mode = :test

GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  :login     => "cubbyholesupersonic-facilitator_api1.gmail.com",
  :password  => "1391005785",
  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AYy7YtND7y2GrQo5eoDJijXGShHH"
)