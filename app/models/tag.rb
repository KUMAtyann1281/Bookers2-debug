class Tag < ApplicationRecord
  has_many :book_tag_relations, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :book_tag_relations, dependent: :destroy

  validates :name, uniqueness: true, presence: true
end
