require 'rails_helper'

RSpec.describe Website, type: :model do

let(:web) { Website }

  describe "Normolize tweets, gitrepos and rubygems" do
    it "should return true" do
      user_name = "Peter"
      expect(web.normolize_tweets(user_name)).should be_truthy
      expect(web.normolize_git_repos(user_name)).should be_truthy
      expect(web.normolize_git_repos(user_name)).should be_truthy
    end

    it "expects nil for a bad input" do
      user_name = "badinput..badinput.."
      expect(web.normolize_tweets(user_name)).to be_nil
      expect(web.normolize_git_repos(user_name)).to be_nil
      expect(web.normolize_git_repos(user_name)).to be_nil
    end
  end

end
