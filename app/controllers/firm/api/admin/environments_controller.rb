class API::Admin::EnvironmentsController < AdminController

  def index
    items = Environment.all
    json_response({items: items}, 200)
  end

end