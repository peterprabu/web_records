class WebsitesController < ApplicationController
	def index
	end

  # method to fetch Twitter, Git and RubyGems records
  def display
  	@user_name 	= "#{params[:user_name]}" 

  	# Return all tweets owned by the user.
  	@tweets     = Website.normolize_tweets(@user_name) # Error handling for tweets

  	# Return all repos owned by the user.
  	@git_repos  = Website.normolize_git_repos(@user_name) # Error handling for git repos

  	# Return all gems owned by the user.
  	@rubygems  	= Website.normolize_ruby_gems(@user_name) # Error handling for ruby gems

  	# for PDF generation
  	respond_to do |format|
	    format.html
	    format.pdf do
		    pdf = Prawn::Document.new
		    send_data Pdf.generate_pdf(@user_name, @tweets, @git_repos, @rubygems), filename: 'report.pdf', type: 'application/pdf'
	    end
  	end
  end
end
