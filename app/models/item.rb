class Item < ApplicationRecord
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :user_id,  :presence  => true
  validates :username, :presence  => true
  validates :content,  :presence  => true
  validates :title,    :presence  => true,
                       :length    => { :minimum => 5 }
  validates :price,    :presence  => true, 
                        numericality: { greater_than_or_equal_to: 1 }
  validates :shipping_price,    :presence  => true
  validates :paypal_email,      :presence  => true
  has_many :comments, :dependent  => :destroy
  has_one :order
  has_many :favorite_items
  has_many :favorited_by, through: :favorite_items, source: :user

  def self.search(search)
  where("title ILIKE ? OR content ILIKE ? OR username ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%") 
  end

end
