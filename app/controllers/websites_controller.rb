require 'twitter.rb'

class WebsitesController < ApplicationController
  def index
  end

  # method to fetch Twitter, Git and RubyGems records
  def display
  	if params[:website]
  		@user_name 	= "#{params[:website][:user_name]}" 
  	else
  		@user_name 	= "#{params[:user_name]}" 
  	end

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
        send_data generate_pdf(@user_name, @tweets, @git_repos, @rubygems), filename: 'report.pdf', type: 'application/pdf'
      end
    end
  end

  def tweets_normolize(user_name)
  	begin
  		tweets = $twitter.user_timeline("#{user_name}")
  		return tweets
  	rescue => e
  		Rails.logger.info "Error occurs while gathering tweets #{e.class} - #{e.message}"
  		return nil
  	end
  end

  def git_repos_normolize(user_name)
  	begin
  		git_repos = $github.repos.list user: "#{user_name}"
  		raise "Error: no responses!" if git_repos.body.empty? 
  		return git_repos
  	rescue => e
  		Rails.logger.info "Error occurs while gathering git repos #{e.class} - #{e.message}"
  		return nil
  	end
  end

  def ruby_gems_normolize(user_name)
  	begin
  		rubygems = Gems.gems("#{user_name}")
  		raise "Error: No user found!" if rubygems.include?("Owner could not be found")
  		return rubygems
  	rescue => e
  		Rails.logger.info "Error occurs while gathering rubygems #{e.class} - #{e.message}"
  		return nil
  	end
  end

  def generate_pdf(user_name, tweets, git_repos, rubygems)
    Prawn::Document.new do
    	text "Twitter, Github and RubyGems Records", :size => 20, :style => :bold, align: :center, :color => "#663333"
      	move_down(30)

      	text "User : #{user_name}".titleize, :size => 15, :style => :bold, :color => "#0066FF"
      	move_down(20)

      	text "Twitter Details", :style => :bold
      	move_down(10)

      	c = 0
		tweets = tweets.map do |t|
		  t_table = make_table([["#{t.text}"]], :column_widths => [500])
		  t_table.draw
		end
		move_down(25)

		text "Git Repo Details", :style => :bold
      	move_down(10)

      	c = 0
		git_repos = git_repos.map do |g|
		  text "#{c+=1}. #{g.name}"
		end

		move_down(25)

		text "Ruby Gems Details", :style => :bold
      	move_down(10)

      	c = 0
		rubygems = rubygems.map do |r|
		  text "#{c+=1}. #{r["name"]}"
		end

		move_down(35)
		text "Copyright © 2015 · All Rights Reserved · Peter", :size => 10, :style => :bold, :color => "#FF0000"

    end.render
  end

end
