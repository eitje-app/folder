class API::EnvironmentsController < BaseController

  def index
    items = Environment.all
    json_response({items: items}, 200)
  end

end