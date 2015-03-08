class Website
  def self.normolize_tweets(user_name)
  	begin
  	  tweets = $twitter.user_timeline("#{user_name}")
      raise "Error: no responses!" if tweets.blank?
  	  return tweets
  	rescue => e
  	  Rails.logger.info "Error occurs while gathering tweets #{e.class} - #{e.message}"
  	  return nil
  	end
  end

  def self.normolize_git_repos(user_name)
  	begin
  	  git_repos = $github.repos.list user: "#{user_name}"
  	  raise "Error: no responses!" if git_repos.body.blank? 
      return git_repos
  	rescue => e
      Rails.logger.info "Error occurs while gathering git repos #{e.class} - #{e.message}"
  	  return nil
  	end
  end

  def self.normolize_ruby_gems(user_name)
  	begin
  	  rubygems = Gems.gems("#{user_name}")
  	  raise "Error: No user found!" if rubygems.include?("Owner could not be found") || rubygems.blank?
  	  return rubygems
  	rescue => e
  	  Rails.logger.info "Error occurs while gathering rubygems #{e.class} - #{e.message}"
  	  return nil
  	end
  end
end