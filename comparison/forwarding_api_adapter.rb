require 'forwardable'

class ForwardingApiAdapter < Struct.new(:thing)
  extend Forwardable

  def_delegators :thing, :id, :name, :to_json

  def as_json
    thing.as_json.merge(path: slug)
  end

  def slug
    name.downcase.gsub(' ', '-')
  end
end

