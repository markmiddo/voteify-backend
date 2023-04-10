class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :patron, index: true
      t.belongs_to :event
      t.integer :status, default: 0, index: true

      t.timestamps
    end
  end
end
