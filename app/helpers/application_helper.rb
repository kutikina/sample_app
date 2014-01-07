module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

	def add_get
  		request.get?
  	end

  	def add_headers
  		request.headers  		
	end

	def add_full_path
		request.fullpath
	end
end
