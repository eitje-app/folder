class ApplicationController < ActionController::API
  
  def json_response(object, status = :ok, e_methods = nil)
    obj = object.is_a?(String) ? {message: object} : object
    mets = (e_methods.is_a?(Array) || e_methods.nil?) ? e_methods : [e_methods]

    if mets
      render json: obj, status: status, methods: mets
    else
      render json: obj, status: status
    end

    return
  end
  
end
