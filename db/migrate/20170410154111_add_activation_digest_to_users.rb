class AddActivationDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :activation_digest, :string
  end
end
