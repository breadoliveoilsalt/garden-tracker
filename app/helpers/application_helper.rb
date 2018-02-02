module ApplicationHelper

  def flash_message
    if flash[:message]
      content_tag(:h3, flash[:message], class: "message")
    end
  end

  def link_to_largest_garden
    largest_garden = Garden.order("square_feet DESC").first
    link_to largest_garden.name, garden_path(largest_garden.id)
  end

  def link_to_garden_with_most_plantings
    garden = Garden.garden_with_most_plantings
    link_to garden.name, garden_path(garden.id)
  end

end
