module ApplicationHelper
	def image_link(link, image)
    raw "<a href='#{link}'><img src='#{image}' /></a>"
  end
end
