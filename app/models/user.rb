class User < ActiveRecord::Base
    attr_accessible :full_name, :username, :password, :password_confirmation
    has_secure_password
end
