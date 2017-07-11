class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :age

  attribute :name_brief
  attribute :average_position_age_diff
  attribute :position

  def name_brief
    name_attrs = [object.last_name]
    # only add first_name if it is present
    name_attrs.unshift(object.first_name) if object.first_name.present?
    case object.sport.name
    when Sport::FOOTBALL
      name_attrs[0] = "#{name_attrs[0][0]}." if name_attrs.length > 1
    when Sport::BASEBALL
      name_attrs.map! { |n| "#{n[0]}." }
    when Sport::BASKETBALL
      name_attrs.last = "#{name_attrs.last[0]}."
    else
      # Non defined sport, just using full name
    end

    name_attrs.join(' ')
  end

  def average_position_age_diff
    if object.age
      average_age = PlayerAnalyzer.average_age_by_position(object.position_id)
      (object.age - average_age).round(2)
    else
      nil
    end
  end

  def position
    object.position.name
  end
end
