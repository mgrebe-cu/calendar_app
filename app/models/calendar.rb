class Calendar < ActiveRecord::Base
    extend Enumerize
    enumerize :color, in: {blue: 0, red: 1, orange: 2, yellow: 3,
                           green: 4, purple: 5, brown: 6}, default: :blue

    attr_accessible :default, :title, :description, :color, :displayed, :description

    belongs_to :user
    has_many :events

    validates :user_id, presence: true
    validates :title, presence: true
    validates :color, presence: true
    validates :default, :inclusion => { :in => [true, false] }

end
