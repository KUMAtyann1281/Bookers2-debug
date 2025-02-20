class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :follower_relationships, source: :followed
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :followed_relationships, source: :follower
  has_many :book_comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  has_many :group_users, dependent: :destroy

  has_one_attached :profile_image

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 20 },
    uniqueness: true

  validates :introduction,
    length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    follower_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following.include?(user)
  end

end
