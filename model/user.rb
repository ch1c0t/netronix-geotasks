require 'securerandom'

class User
  include Mongoid::Document

  field :token, default: ->{ SecureRandom.urlsafe_base64 64 }

  has_one :task

  # Should tokens be encrypted? For large number of users, it might be
  # bad performance-wise. To use BCrypt::Password#==, I will have to
  # get all users on each request:
  #     
  #   all.to_a.find { |document| document.token == token }
  def self.find_by_token token
    where(token: token).first
  end
end
