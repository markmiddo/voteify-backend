class CreateTermsAndConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :terms_and_conditions do |t|
      t.string :title
      t.string :body

      t.timestamps
    end
  end
end
