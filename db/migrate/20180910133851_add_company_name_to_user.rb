class AddCompanyNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :company_name, :string
  end
end
