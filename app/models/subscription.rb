class Subscriptions < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :user, class_name: "User"
  belongs_to :calendar, class_name: "Calendar"

  validates :user_id, presence: true
  validates :calendar_id, presence: true
end
