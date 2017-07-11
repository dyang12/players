class PlayerAnalyzer
  # TODO cache this value until another import in triggered
  # returns 0 if no players found with valid age
  def self.average_age_by_position(position_id)
    # find players with same position ignoring players with nil age
    positioned_players = Player.where('position_id = ? AND age IS NOT NULL', position_id)

    if positioned_players.any?
      positioned_players.sum(:age).fdiv(positioned_players.count)
    else
      0
    end
  end
end
