class Subscription < ActiveRecord::Base
  extend Enumerize
  enumerize :color, in: {blue: 0, red: 1, orange: 2, yellow: 3,
                         green: 4, purple: 5, brown: 6}, default: :blue
                         
  attr_accessible :subscribed, :color, :rw, :displayed, :title, :calendar_id, :user_id

  belongs_to :user
  belongs_to :calendar

  validates :user_id, presence: true
  validates :calendar_id, presence: true
  validates :color, presence: true
end
