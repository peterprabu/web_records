class Pdf
  def self.generate_pdf(user_name, tweets, git_repos, rubygems)
  	Prawn::Document.new do
  		text "Twitter, Github and RubyGems Records", :size => 20, :style => :bold, align: :center, :color => "#663333"
  		move_down(30)

  		text "User : #{user_name}".titleize, :size => 15, :style => :bold, :color => "#0066FF"
  		move_down(20)

  		text "Twitter Details", :style => :bold
  		move_down(10)

  		c = 0
  		if !tweets.blank?
  		  tweets = tweets.map do |t|
  		    t_table = make_table([["#{t.text}"]], :column_widths => [500])
  		    t_table.draw
  		  end
  		else
  		  text "No records found..."
  		end
  		move_down(25)

  		text "Git Repo Details", :style => :bold
  		move_down(10)

  		c = 0
  		if !git_repos.blank?
  		  git_repos = git_repos.map do |g|
  		    text "#{c+=1}. #{g.name}"
  		  end
  		else
  		  text "No records found..."
  		end

  		move_down(25)

  		text "Ruby Gems Details", :style => :bold
  		move_down(10)

  		c = 0
  		if !rubygems.blank?
  		  rubygems = rubygems.map do |r|
  			text "#{c+=1}. #{r["name"]}"
  		  end
  		else
  		  text "No records found..."
  		end

  		move_down(35)
  		text "Copyright © 2015 · All Rights Reserved · Peter", :size => 10, :style => :bold, :color => "#FF0000"

  	end.render
  end
end