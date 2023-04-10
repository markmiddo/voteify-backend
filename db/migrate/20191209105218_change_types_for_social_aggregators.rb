class ChangeTypesForSocialAggregators < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :fb_pixel, :string
    change_column :events, :google_analytic, :string
  end
end
