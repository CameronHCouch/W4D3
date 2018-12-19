# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }
    after_initialize :ensure_session_token

    attr_reader :password

    has_many :cats,
        class_name: :Cat,
        foreign_key: :user_id 

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def ensure_session_token
        self.session_token  ||= User.generate_session_token
    end

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return nil unless user && user.is_password?(password) 
        user
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        decrypted = BCrypt::Password.new(self.password_digest)
        decrypted.is_password?(password)
    end
end
