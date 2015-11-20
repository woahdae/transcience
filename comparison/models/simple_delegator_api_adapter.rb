require 'delegate'

class SimpleDelegatorApiAdapter < SimpleDelegator
  def as_json
    super.merge(path: slug)
  end

  def slug
    name.downcase.gsub(' ','-')
  end
end
