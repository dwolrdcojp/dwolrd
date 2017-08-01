class Order < ApplicationRecord
  belongs_to :item
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
end
