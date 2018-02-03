module ApplicationHelper

  def flash_message
    if flash[:message]
      content_tag(:h3, flash[:message], class: "message")
    end
  end

  def link_to_largest_garden
    if Garden.any?
      largest_garden = Garden.order("square_feet DESC").first
      link_to largest_garden.name, garden_path(largest_garden.id)
    else
      "No gardens have been created yet."
    end
  end

  def link_to_garden_with_most_plantings
    if Garden.any?
      garden = Garden.garden_with_most_plantings
      link_to garden.name, garden_path(garden.id)
    else
      "No gardens have been created yet."
    end
  end

  def display_any_errors(object)
    render partial: 'layouts/errors', locals: {errors: object.errors} if object.errors.any?
  end

end
