class User < ApplicationRecord
  # Devise modules for authentication and registration
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:login]

  # Attribute accessor for the virtual "login" field used for authentication
  attr_accessor :login

  # List of restricted usernames that users are not allowed to use
  RESTRICTED_USERNAMES = %w(admin support help).freeze
  
  # Model associations
  has_many :messages
  has_many :marks
  has_many :issued_tokens, class_name: 'Token', foreign_key: 'issuer_id'
  has_many :received_tokens, class_name: 'Token', foreign_key: 'recipient_id'

  # Validations

  # Ensure the username is unique, case insensitive
  validates :username, presence: true, 
                       uniqueness: { case_sensitive: false }, 
                       length: { minimum: 6, maximum: 50 }
                       
  # Optional fields with length validations
  validates :first_name, length: { minimum: 1, maximum: 50 }, allow_blank: true
  validates :last_name, length: { minimum: 1, maximum: 50 }, allow_blank: true

  # Validate email format
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Bio validation
  validates :bio, length: { maximum: 500 }, allow_blank: true

  # Custom validation to check restricted usernames
  validate :username_not_restricted 

  # Override Devise's method to allow authentication using either username or email
  # This method is called by Devise to find the user in the database
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.strip.downcase }]).first
  end

  # Getter for the login attribute
  def login
    @login || self.username || self.email
  end

  private

  # Custom validation to prevent the use of restricted usernames
  def username_not_restricted
    if RESTRICTED_USERNAMES.include?(username&.downcase)
      errors.add(:username, "is restricted. Please choose another one.")
    end
  end
end
