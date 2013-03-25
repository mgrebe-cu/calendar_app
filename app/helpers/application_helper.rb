# This module is a rails helper for the calendar application
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "GrebeCalendarApp"
    if page_title.empty?
      base_title
    else
      "#{base_title}: #{page_title}"
    end
  end
  
  # Returns the current URL with new parameters attached
  def current_url(new_params)
    url_for :params => params.merge(new_params)
  end
end
