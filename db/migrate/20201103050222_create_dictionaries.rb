class CreateDictionaries < ActiveRecord::Migration[5.2]
  def change
    create_table :dictionaries do |t|
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
