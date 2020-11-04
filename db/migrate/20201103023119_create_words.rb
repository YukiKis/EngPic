class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :meaning, null: false
      t.text :sentence
      t.string :image_id, null: false
      t.timestamps
    end
  end
end
