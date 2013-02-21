class Calendar < ActiveRecord::Base
    attr_accessible :default

    belongs_to :user
    has_many :events

    validates :user_id, presence: true
    validates :default, presence: true
end
