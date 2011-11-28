module ApplicationHelper
	def image_link(link, image)
		if !link.empty?
    	raw "<a href='#{link}'><img src='#{image}' /></a>"
    end
  end
end
