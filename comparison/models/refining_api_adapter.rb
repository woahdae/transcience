require_relative 'thing'

module RefiningApiAdapter
  refine Thing do
    def as_json
      super.merge(path: slug)
    end

    def slug
      name.downcase.gsub(' ','-')
    end
  end
end

