class CbsApiService
  class RequestFailedError < StandardError; end
  class UnexpectedResponseError < StandardError; end

  # returns an array of player objects
  # possible errors:
  #   CbsApiService::RequestFailedError- response returned unsuccessful status
  #   JSON::ParserError- invalid json body returned by cbs api
  #   CbsApiService::UnexpectedResponseError- response did not return expected 
  def players(sport)
    response = connection.get do |req|
      req.url '/fantasy/players/list'
      req.params = base_params
      req.params['SPORT'] = sport.downcase
    end

    if response.success?
      parse_response(response: response, keys: %w(body players))
    else
      raise RequestFailedError.new(response.body)
    end
  end

  private

  def connection
    @connection ||= Faraday.new(url: base_url) do |c|
      c.adapter Faraday.default_adapter
    end
  end

  def parse_response(response:, keys:)
    # cbs api seems to return response with content-type = 'text/plain'
    response_body = JSON.parse(response.body)
    players_array = response_body.dig(*keys)

    if players_array.nil?
      raise UnexpectedResponseError.new(I18n.t('services.cbs_api_service.errors.unexpected_response'))
    else
      players_array
    end
  end

  def base_url
    Rails.configuration.cbs_api['base_url']
  end

  def base_params
    {
      'version' => Rails.configuration.cbs_api['version'],
      'response_format' => Rails.configuration.cbs_api['response_type']
    }
  end
end
