class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :word_id, null: false
      t.integer :dictionary_id, null: false
      t.timestamps
    end
  end
end
