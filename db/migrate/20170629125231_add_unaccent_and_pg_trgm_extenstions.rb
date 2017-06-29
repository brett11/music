class AddUnaccentAndPgTrgmExtenstions < ActiveRecord::Migration[5.0]
  def up
    execute "create extension pg_trgm"
    execute "create extension unaccent"
  end

  def down
    execute "drop extension pg_trgm"
    execute "drop extension unaccent"
  end
end
