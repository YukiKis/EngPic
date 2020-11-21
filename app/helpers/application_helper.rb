module ApplicationHelper
  def counter(number, resource)
    number.to_s + " " + resource.pluralize(number)    
  end
  
  def full_title(page_title = "")
    base_title = "EngPic"
    if page_title.empty?
      title = base_title
    else
      title = base_title + " | " + page_title
    end
    return title
  end
end
