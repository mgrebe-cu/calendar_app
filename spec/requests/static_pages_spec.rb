require 'spec_helper'

describe "StaticPages" do

    subject { page }

    describe "Home page" do
        before { visit root_path }

        it { should have_selector('h1',    text: 'Calendaring Application') }
        it { should have_selector('title', text: 'CalendarApp') }
        it { should have_link('Sign In') }
        it { should have_link('Create Account') }
    end
end
