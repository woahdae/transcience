require 'casting'

require_relative 'thing'

module CastingApiAdapter
  def as_json
    super.merge(path: slug)
  end

  def slug
    name.downcase.gsub(' ','-')
  end
end

