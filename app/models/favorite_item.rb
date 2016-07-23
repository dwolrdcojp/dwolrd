class FavoriteItem < ApplicationRecord
  belongs_to :item
  belongs_to :user
  validates :user_id, :uniqueness => { :scope => :item_id }
end
