class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.string :answer_value
      t.belongs_to :patron
      t.belongs_to :question

      t.timestamps
    end
  end
end
