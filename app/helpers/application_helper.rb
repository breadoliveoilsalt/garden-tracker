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

  def display_any_errors(object)
    render partial: 'layouts/errors', locals: {errors: object.errors} if object.errors.any?
    # from new account - render partial: 'layouts/errors', locals: {errors: @user.errors} if @user.errors.any?
  end
  
end
