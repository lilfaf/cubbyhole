class PaymentsController < ApplicationController

  def test

    #create a fake credit_card
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name         => 'Bob',
      :last_name          => 'Bobsen',
      :number             => '6011200981567548',
      :month              => '1',
      :year               => '2019',
      :verification_value => '000'
    )

    puts "==========================="
    puts "=======TEST PURPOSE========"
    puts "==========================="
    puts "Test mode : #{GATEWAY.test?}"

    options = {
      :period => "Month",
      :frequency => 1,
      :start_date => Time.now,
      :description => "this is a test recurring subscription"
    }

    #process fake recurring
    recurring(999, @credit_card, options)
  end


  def recurring(amount, credit_card, options)

    #amount – The amount to be charged to the customer at each interval as an Integer value in cents.
    #credit_card – The CreditCard details for the transaction.
    #options – A hash of parameters.

    #Options

    #:period – [Day, Week, SemiMonth, Month, Year] default: Month
    #:frequency – a number
    #:cycles – Limit to certain # of cycles (OPTIONAL)
    #:start_date – When does the charging starts (REQUIRED)
    #:description – The description to appear in the profile (REQUIRED)

    if credit_card.valid?
      response = GATEWAY.recurring(amount, credit_card, options)
      if response.success?
        puts "Recurring payment successfull."
      else
        raise StandardError, response.message
      end
    else
      puts "Credit card invalid"
    end
  end
end