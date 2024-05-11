require 'active_support/message_encryptor'

module Encryption
  secret_password = ENV['SECRET_ENCRYPTION_KEY']
  salt = ENV['SECRET_ENCRYPTION_SALT']
  key = ActiveSupport::KeyGenerator.new(secret_password).generate_key(salt, 32)
  iv = SecureRandom.hex(12)

  ENCRYPTOR = ActiveSupport::MessageEncryptor.new(key, iv)

  def self.encrypt(value)
    ENCRYPTOR.encrypt_and_sign(value.to_s)
  end

  def self.decrypt(encrypted_value)
    ENCRYPTOR.decrypt_and_verify(encrypted_value).to_i
  end
end
