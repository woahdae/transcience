class Thing < Struct.new(:id, :name)
  def as_json
    {
      id: id,
      name: name
    }
  end

  def to_json
    as_json.to_json
  end
end
