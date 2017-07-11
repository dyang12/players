class PlayersController < ApplicationController
  def show
    player = Player.joins(:sport).find_by(id: params[:id])

    if player
      json_response(player)
    else
      message = "Unknown Player! id: #{params[:id]}"
      json_response({:error_message => message}, :not_found)
    end
  end

  def import
    if PlayerImporter.import(params[:sport])
      head :ok
    else
      json_response({:error_message => message}, :unprocessable_entity)
    end
  end
end
