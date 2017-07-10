class Position < ApplicationRecord
  NONE = "NA".freeze

  validates_presence_of :sport
  validates_uniqueness_of :name, scope: :sport_id
  
  before_validation :upcase_name

  belongs_to :sport

  private

  def upcase_name
    name.upcase!
  end
end
