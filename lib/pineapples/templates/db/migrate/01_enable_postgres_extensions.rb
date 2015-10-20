class EnablePostgresExtensions < ActiveRecord::Migration
  def self.up
    enable_extension 'plpgsql' if !extension_enabled? 'plpgsql'
    enable_extension 'hstore' if !extension_enabled? 'hstore'
    enable_extension 'ltree'  if !extension_enabled? 'ltree'
    enable_extension 'uuid-ossp'  if !extension_enabled? 'uuid-ossp'
  end

  def self.down
    disable_extension 'plpgsql' if extension_enabled? 'plpgsql'
    disable_extension 'hstore' if extension_enabled? 'hstore'
    disable_extension 'ltree' if extension_enabled? 'ltree'
    disable_extension 'uuid-ossp' if extension_enabled? 'uuid-ossp'
  end
end
