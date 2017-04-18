class RemovePrimaryKeysFromJoinTables < ActiveRecord::Migration[5.0]
  #http://stackoverflow.com/questions/15622303/how-to-change-primary-key-in-rails-migration-file
  def change
    execute "ALTER TABLE `artists_concerts` DROP PRIMARY KEY"
    execute "ALTER TABLE `artists_users` DROP PRIMARY KEY"
    execute "ALTER TABLE `albums_artists` DROP PRIMARY KEY"
  end
end
