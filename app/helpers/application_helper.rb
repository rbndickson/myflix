module ApplicationHelper
  def star_options
    [1, 2, 3, 4, 5].collect { |number| [pluralize(number, 'star'), number] }
  end

  def options_for_video_review(selected = nil)
    options_for_select(star_options, selected)
  end

  def average_rating_options
    (10..50).map do |num|
      n = num / 10.0
      [n.to_s, n]
    end
  end

  def options_for_rating_filter(selected = nil)
    options_for_select(average_rating_options, selected)
  end

  def gravatar_for(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end
end
