class PlayerImporter
  #TODO add locking to prevent creation of duplicate records if importer is run simultaneously
  def self.import(sport_name)
    players_by_position = players_by_position(sport_name)

    Sport.transaction do
      sport = Sport.find_or_create_by!(name: sport_name)

      players_by_position.each do |position_name, players|
        # some players have no position, explicitly setting position of these players to "NA"
        position_name ||= Position::NONE
        position = Position.find_or_create_by!(name: position_name, sport: sport)
        create_players!(sport: sport, position: position, players: players)
      end
    end

    true
  # TODO implement better error capture, return object with explicit errors rather than just return false
  rescue CbsApiService::RequestFailedError, CbsApiService::UnexpectedResponseError, JSON::ParserError => e
    false
  rescue ActiveRecord::RecordInvalid => e
    false
  end

  def self.players_by_position(sport)
    service = CbsApiService.new
    service.players(sport).group_by { |player_attrs| player_attrs['position'] }
  end

  def self.create_players!(sport:, position:, players:)
    players.each do |player_attrs|
      player = Player.find_or_initialize_by(external_id: player_attrs['id'])

      player.assign_attributes(
        first_name: player_attrs['firstname'],
        last_name: player_attrs['lastname'],
        age: player_attrs['age'],
        sport: sport,
        position: position
      )

      player.save!
    end
  end
end
