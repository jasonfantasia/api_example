class User < ApplicationRecord
  has_secure_password

  has_many :widgets

  validates :name, presence: true, length: { maximum: 255 }
  validates :email,
    presence: true,
    length: { maximum: 255 },
    uniqueness: { case_sensitive: false }
  validates :auth_token, uniqueness: true

  def generate_auth_token
    auth_token = new_token

    # get a new token if there's a collision
    while User.where(auth_token: auth_token).any?
      auth_token = new_token
    end

    self.update(
      auth_token: auth_token,
      auth_token_create_date: DateTime.current
    )

    auth_token
  end

  def revoke_auth_token
    self.update(auth_token: nil, auth_token_create_date: nil)
  end

  private

  def new_token
    SecureRandom.uuid
  end
end
