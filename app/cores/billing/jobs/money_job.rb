class Billing::MoneyJob < ApplicationJob

  def perform
    puts "this job is beautifully running!"
  end

end