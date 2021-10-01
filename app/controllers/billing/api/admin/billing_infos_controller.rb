class API::Admin::BillingInfosController < AdminController

  def index
    items = Billing::Info.all
    json_response({items: items}, 200)
  end

end