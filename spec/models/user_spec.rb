require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  fixtures :users
  before :each do
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  describe "Simple Validation Test" do
    it "user should be valid" do
      expect(@user).to be_valid
    end

    it "name should be present" do
      @user.name = "  "
      expect(@user).not_to be_valid
    end

    it "email should be present" do
      @user.email = "  "
      expect(@user).not_to be_valid
    end

    it "name should not be too long" do
      @user.name  = "a" * 51
      expect(@user).not_to be_valid
    end

    it "email should not be too long" do
      @user.email  = "a" * 244 + "@example.com"
      expect(@user).not_to be_valid
    end

    it "email address should be uniquie" do
      user = FactoryGirl.create(:user)
      duplicate_user = user.dup
      # 大文字・小文字のバリデート
      duplicate_user.email = user.email.upcase
      expect(duplicate_user).not_to be_valid
    end

    it "email addresses should be saved as lower-case " do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user_mixed_case_email = FactoryGirl.create(:user, email: mixed_case_email)
      expect(user_mixed_case_email.email).to eq(mixed_case_email.downcase)
    end

    it "password should be present (nonblank)" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).not_to be_valid
    end

    it "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).not_to be_valid
    end

    it "authenticated? should return false for a user with nil digest" do
      expect(@user.authenticated?(:remember, "")).to be_falsey
    end
  end

  describe "Email Format Test" do

    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      it "#{valid_address} should be proper format" do
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end

    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      it "#{invalid_address} should not be proper format" do
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "Relationship Test" do
    it "should follow and unfollow a user" do
      michael = users(:michael)
      mary = users(:mary)
      assert_equal false, michael.following?(mary)
      michael.follow(mary)
      assert michael.following?(mary)
      assert mary.followers.include?(michael)
      michael.unfollow(mary)
      assert_equal false, michael.following?(mary)
    end
  end

end
