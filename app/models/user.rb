class User < ActiveRecord::Base
    extend Enumerize
    enumerize :default_view, in: {month:  0, week: 1, 
                                  day: 2, list: 3}, default: :month

    attr_accessible :full_name, :username, :password, 
                    :password_confirmation, :default_view
    has_secure_password

    has_many :calendars

    validates :full_name,  presence: true, length: { maximum: 50 }
    validates :username,  presence: true, length: { maximum: 20 }, uniqueness: true
    validates :password, length: { minimum: 6, maximum: 20 }, 
                         format: { :with => /^.*(?=.*\d)(?=.*[a-zA-Z]).*$/,
                                   :message => "must contain a number and a letter" }
    validates :password_confirmation, presence: true
 
end
