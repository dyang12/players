class Player < ApplicationRecord
  validates_presence_of :external_id, :last_name, :position, :sport
  validates_uniqueness_of :external_id

  belongs_to :sport
  belongs_to :position
end
