class Item < ApplicationRecord
  validates :content, :presence => true
  validates :title,   :presence => true,
                      :length   => { :minimum => 5 }
end
