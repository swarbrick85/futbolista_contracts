class CreateFutbolistas < ActiveRecord::Migration[5.2]
  def change
    create_table :futbolistas do |t|
      t.string :name
      t.string :country_of_origin
      t.string :position
      t.integer :agent_id
      t.integer :club_id
      t.integer :contract_id
      t.integer :user_id
    end
  end
end
