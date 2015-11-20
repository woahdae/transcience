require 'casting'

require_relative 'thing'

module CastingApiAdapter
  # Casting totally fails here.
  #
  # When using `Casting::Client#delegate`, we can't call super *nor* make an
  # alias chain, so we're forced to re-define #as_json to add the path property.
  #
  # When using `Casting::Client#cast_as`, it doesn't overwrite existing methods
  # at all, so our enhanced `#as_json` never gets called.
  def as_json
    {
      id: id,
      name: name,
      path: name.downcase.gsub(' ','-')
    }
  end

  def slug
    name.downcase.gsub(' ','-')
  end
end

