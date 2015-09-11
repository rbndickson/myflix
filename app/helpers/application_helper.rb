module ApplicationHelper
  def star_options
    [5,4,3,2,1].collect { |x| [pluralize(x, 'star'), x] }
  end
end
