module ApplicationHelper

  def flash_message
    render partial: 'layouts/message', locals: {message: flash[:message]} if flash[:message]
  end

  def display_any_errors(object)
    render partial: 'layouts/errors', locals: {errors: object.errors} if object.errors.any?
  end

  def visiting_initial_pages
    params[:action] == "home"
  end

end


# Do not need these any more, but keeping as possible precedents. I previously
# used these as helper methods in users/show view.

  # def flash_message
  #   if flash[:message]
  #     content_tag(:h3, flash[:message], class: "message")
  #   end
  # end

  # def link_to_largest_garden
  #   if Garden.any?
  #     largest_garden = Garden.largest_garden
  #     link_to largest_garden.name, garden_path(largest_garden.id)
  #   else
  #     "No gardens have been created yet."
  #   end
  # end
  #
  # def link_to_garden_with_most_plantings
  #   if Garden.any?
  #     garden = Garden.garden_with_most_plantings
  #     link_to garden.name, garden_path(garden.id)
  #   else
  #     "No gardens have been created yet."
  #   end
  # end
