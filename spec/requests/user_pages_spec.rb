require 'spec_helper'

describe "UserPages" do

    subject { page }

    describe "Signup Page" do
        before { visit signup_path }

        it { should have_selector('title', text: 'GrebeCalendarApp: Create Account') }
        it { should have_selector('h1',    text: 'Create Account') }
    end
end
