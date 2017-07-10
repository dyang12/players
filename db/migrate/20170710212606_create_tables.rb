class CreateTables < ActiveRecord::Migration[5.1]
  def up
    create_table :sports do |t|
      t.string :name
    end

    create_table :positions do |t|
      t.string :name
      t.integer :sport_id
    end

    create_table :players do |t|
      t.string :external_id
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.integer :position_id
      t.integer :sport_id
    end

    add_index :positions, :sport_id

    add_index :players, :sport_id
    add_index :players, :position_id
  end

  def down
    drop_table :sports
    drop_table :positions
    drop_table :players
  end
end
