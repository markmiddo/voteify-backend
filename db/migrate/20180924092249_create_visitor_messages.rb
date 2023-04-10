class CreateVisitorMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :visitor_messages do |t|
      t.string :email
      t.string :message_text

      t.timestamps
    end
  end
end
