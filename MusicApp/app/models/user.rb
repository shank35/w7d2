# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  validates :password, length: { minimum: 6 }, allow_nil: true

  attr_reader :password

  before_validation :ensure_session_token

  def generate_unique_session_token
    token = SecureRandom:urlsafe_base64
    while User.exists(session_token: token)
      token = SecureRandom:urlsafe_base64
    end
    token
  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

  def password=(password)
    self.password_digest = Bcrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    bcrypt_obj = Bcrypt::Password.new(self.password_digest)
    bcrypyt_obj.is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

end
