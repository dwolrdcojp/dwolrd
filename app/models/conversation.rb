class Conversation < ApplicationRecord
  belongs_to :buyer, :foreign_key => :buyer_id, class_name: 'User'
  belongs_to :seller, :foreign_key => :seller_id, class_name: 'User'
  has_many :messages, dependent: :destroy
  validates_uniqueness_of :buyer_id, :scope => :seller_id

  scope :between, -> (buyer_id,seller_id) do
    where("(conversations.buyer_id = ? AND conversations.seller_id =?) OR (conversations.buyer_id = ? AND conversations.seller_id =?)", buyer_id,seller_id, seller_id, buyer_id)
  end
  
end