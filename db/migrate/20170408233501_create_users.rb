class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name_last
      t.string :name_first
      t.string :email
      t.string :password_digest
      t.boolean :admin, default: false
      t.boolean :activated, default: false

      t.timestamps
    end
  end
end
