class Order < ApplicationRecord
  belongs_to :item
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  validates :name,  :presence  => true
  validates :address, :presence  => true
  validates :city,  :presence  => true
  validates :state,    :presence  => true
  validates :zip,    :presence  => true
  validates :country,    :presence  => true
end
