class Item < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, :presence  => true
  validates :content, :presence  => true
  validates :title,   :presence  => true,
                      :length    => { :minimum => 5 }
  has_many :comments, :dependent => :destroy
  has_many :orders
  
end
