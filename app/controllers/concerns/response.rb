module Response
  def json_response(response_body, status=:ok)
    render json:response_body, status: status
  end
end
