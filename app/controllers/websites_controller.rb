class WebsitesController < ApplicationController
	def index
	end

  # method to fetch Twitter, Git and RubyGems records
  def display
  	@user_name 	= "#{params[:user_name]}" 

  	# Return all tweets owned by the user.
  	@tweets     = tweets_normolize(@user_name) # Error handling for tweets

  	# Return all repos owned by the user.
  	@git_repos  = git_repos_normolize(@user_name) # Error handling for git repos

  	# Return all gems owned by the user.
  	@rubygems  	= ruby_gems_normolize(@user_name) # Error handling for ruby gems

  	# for PDF generation
  	respond_to do |format|
	  format.html
	  format.pdf do
		pdf = Prawn::Document.new
		  send_data Pdf.generate_pdf(@user_name, @tweets, @git_repos, @rubygems), filename: 'report.pdf', type: 'application/pdf'
	  end
  	end
  end

  def tweets_normolize(user_name)
  	begin
  	  tweets = $twitter.user_timeline("#{user_name}")
      raise "Error: no responses!" if tweets.blank?
  	  return tweets
  	rescue => e
  	  Rails.logger.info "Error occurs while gathering tweets #{e.class} - #{e.message}"
  	  return nil
  	end
  end

  def git_repos_normolize(user_name)
  	begin
  	  git_repos = $github.repos.list user: "#{user_name}"
  	  raise "Error: no responses!" if git_repos.body.blank? 
      return git_repos
  	rescue => e
      Rails.logger.info "Error occurs while gathering git repos #{e.class} - #{e.message}"
  	  return nil
  	end
  end

  def ruby_gems_normolize(user_name)
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
