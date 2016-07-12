class Item < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploaders :images, PictureUploader
  validates :user_id, :presence  => true
  validates :content, :presence  => true
  validate  :images_size
  validates :title,   :presence  => true,
                      :length    => { :minimum => 5 }
  has_many :comments, :dependent => :destroy
  has_many :orders
  
  private

    # Validates the size of an uploaded picture
    def images_size
      if images.size > 5.megabytes
        errors.add(:images, "should be less than 5MB")
      end
    end
end
