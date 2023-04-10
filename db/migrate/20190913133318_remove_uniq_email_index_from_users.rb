class RemoveUniqEmailIndexFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_index :users, :email
    add_index :users, %i[email provider], unique: true
  end

  def down
    remove_index :users, %i[email provider]
    add_index :users, :email, unique: true
  end
end
