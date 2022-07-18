require 'casting'

require_relative 'thing'

module CastingApiAdapter
  # Casting depends on explicit delegation or method_missing.
  # Overriding existing methods won't hit method_missing because they are not
  # missing, so explicit delegation must be used.
  def as_json
    super.merge({
      path: name.downcase.gsub(' ','-')
    })
  end

  def to_json
    cast(:as_json, CastingApiAdapter).to_json
  end

  def slug
    name.downcase.gsub(' ','-')
  end
end

