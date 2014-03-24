class PaymentsController < ApplicationController
  def new
    if not user_signed_in?
      redirect_to new_user_session_url
    end
  end

  def create
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name         => params[:first_name],
      :last_name          => params[:last_name],
      :number             => params[:number],
      :month              => params[:month],
      :year               => params[:year],
      :verification_value => params[:verification_value]
    )

    #@credit_card = ActiveMerchant::Billing::CreditCard.new(
      #:first_name         => 'Bob',
      #:last_name          => 'Bobsen',
      #:number             => '6011200981567548',
      #:month              => '1',
      #:year               => '2019',
      #:verification_value => '000'
    #)

    #Options
    #:period – [Day, Week, SemiMonth, Month, Year] default: Month
    #:frequency – a number
    #:cycles – Limit to certain # of cycles (OPTIONAL)
    #:start_date – When does the charging starts (REQUIRED)
    #:description – The description to appear in the profile (REQUIRED)
    options = {
      :period => "Month",
      :frequency => 1,
      :start_date => Time.now,
      :description => "Recurring subscription"
    }

    if @credit_card.valid?
      recurring(current_user.plan.price, @credit_card, options)
    else
      flash[:alert] = "Credit Card Invalid."
      render "new"
    end
  end

  def recurring(amount, credit_card, options)
    #amount – The amount to be charged to the customer at each interval as an Integer value in cents.
    #credit_card – The CreditCard details for the transaction.
    #options – A hash of parameters.
    response = GATEWAY.recurring(amount, credit_card, options)
    if response.success?
      flash[:notice] = "Subcribe sucessfully."
      redirect_to root_url
      #return  response.params["profile_id"]
    else
      raise StandardError, response.message
    end
  end
end