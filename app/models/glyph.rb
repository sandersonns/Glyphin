class Glyph < ApplicationRecord
  # Existing Associations
  belongs_to :user
  belongs_to :what3words_address, class_name: 'What3words'

  # Validations
  validates :address, presence: true, uniqueness: true

  # Set a default value for glyph_privacy
  after_initialize :set_default_privacy, if: :new_record?

  private

  def set_default_privacy
    self.glyph_privacy ||= false
  end
end
