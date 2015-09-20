module ApplicationHelper
  def star_options
    [1, 2, 3, 4, 5].collect { |number| [pluralize(number, 'star'), number] }
  end

  def options_for_video_review(selected = nil)
    options_for_select(star_options, selected)
  end
end
