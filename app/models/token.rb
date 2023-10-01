class Token < ApplicationRecord
  # Relationships
  belongs_to :issuer, class_name: 'User', foreign_key: 'issuer_id' # The user who issues/generates the token
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id', optional: true # The user for whom the token is meant (optional)

  # Validations
  validates :token_value, presence: true, uniqueness: true # Ensure each token is unique
  validate :expiration_date_valid # Custom validation for expiration date

  # Generates a unique token
  before_create :generate_token

  # Checks if the token has expired
  def expired?
    expires_at.present? && Time.now > expires_at
  end

  private

  # Generate a unique token for the record
  def generate_token
    # Modify this method to use other token generation methods if needed
    self.token_value = SecureRandom.hex(10) until token_value.present? && !Token.exists?(token_value: token_value)
  end

  # Custom validation to ensure the expiration date is in the future if provided
  def expiration_date_valid
    errors.add(:expires_at, "should be in the future") if expires_at.present? && expires_at <= Time.now
  end
end
