class Subscription < ActiveRecord::Base
  attr_accessible :subscribed, :color, :rw, :displayed, :title, :calendar_id, :user_id

  belongs_to :user
  belongs_to :calendar

  validates :user_id, presence: true
  validates :calendar_id, presence: true
  validates :color, presence: true
end
