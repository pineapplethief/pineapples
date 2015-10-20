class AddRoleFieldToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :role, null: false, default: 'guest', index: true
    end
  end
end
