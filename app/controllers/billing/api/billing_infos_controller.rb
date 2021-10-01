class API::BillingInfosController < BaseController

  def index
    items = Billing::Info.all
    json_response({items: items}, 200)
  end

end