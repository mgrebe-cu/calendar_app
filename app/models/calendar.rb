class Calendar < ActiveRecord::Base
    attr_accessible :default, :title

    belongs_to :user
    has_many :events

    validates :user_id, presence: true
    validates :default, presence: true
    validates :title, presence: true
end
