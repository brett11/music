class CreateFanships < ActiveRecord::Migration[5.0]
  def change
    create_table :fanships do |t|
      t.integer :user_id
      t.integer :artist_id

      t.timestamps
    end
    add_index :fanships, :user_id
    add_index :fanships, :artist_id
    add_index :fanships, [:user_id, :artist_id], unique: true
  end
end
