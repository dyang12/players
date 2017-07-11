class Sport < ApplicationRecord
  PRIMARY_SPORTS = [
    FOOTBALL = 'football',
    BASEBALL = 'baseball',
    BASKETBALL = 'basketball'
  ].freeze
  
  validates :name, :presence => true, :uniqueness => true

  before_validation :downcase_name

  has_many :players

  private

  def downcase_name
    name.downcase!
  end
end
