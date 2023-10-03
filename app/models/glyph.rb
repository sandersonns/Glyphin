class Glyph < ApplicationRecord
  belongs_to :user
  belongs_to :what3words_address, class_name: 'What3words'
  validates :address, presence: true, uniqueness: true
end
