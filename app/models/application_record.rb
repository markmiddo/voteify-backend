class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :pagination, -> (params) { limit(params[:limit]).offset(params[:offset]) }
end
