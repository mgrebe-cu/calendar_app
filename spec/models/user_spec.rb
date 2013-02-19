require 'spec_helper'

describe User do
    before do
        @user = User.new(full_name: "Example User", username: "user", 
                         password: "foobar1", password_confirmation: "foobar1")
    end

    subject { @user }

    it { should respond_to(:full_name) }
    it { should respond_to(:username) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should be_valid }

    describe "when full name is not present" do
        before { @user.full_name = " " }
        it { should_not be_valid }
    end

    describe "when username is not present" do
        before { @user.username = " " }
        it { should_not be_valid }
    end

    describe "when full name is too long" do
        before { @user.full_name = "a" * 51 }
        it { should_not be_valid }
    end

    describe "when user name is too long" do
        before { @user.username = "a" * 21 }
        it { should_not be_valid }
    end

    describe "when password is not present" do
        before { @user.password = @user.password_confirmation = " " }
        it { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
        before { @user.password_confirmation = "mismatch" }
        it { should_not be_valid }
    end

    describe "when password confirmation is nil" do
        before { @user.password_confirmation = nil }
        it { should_not be_valid }
    end

    describe "with a password that's too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid }
    end

    describe "with a password that's has no numbers" do
        before { @user.password = @user.password_confirmation = "Abcdef" }
        it { should be_invalid }
    end

    describe "with a password that's has no letters" do
        before { @user.password = @user.password_confirmation = "123456" }
        it { should be_invalid }
    end

    describe "when username is already taken" do
        before do
            user_with_same_name = @user.dup
            user_with_same_name.save
        end

        it { should_not be_valid}
    end

end
