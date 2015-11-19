require 'minitest/autorun'

class String
  def unindent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
