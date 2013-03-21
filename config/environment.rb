# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CalendarApp::Application.initialize!

ENV['TZ'] = 'utc'
Struct.new("CalList",:id,:title)
