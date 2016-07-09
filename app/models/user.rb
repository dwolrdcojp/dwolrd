class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_validation :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :items,  :dependent  => :destroy
  has_many :comments
  validates :email, :uniqueness => true

  private

    def downcase_email
      self.email = email.downcase if email.present?
    end

end
