class What3words < ApplicationRecord
  validates :address, presence: true, uniqueness: true
  has_many :glyphs, foreign_key: 'what3words_address_id'
end
