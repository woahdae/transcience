class Character
  def describe
    io.puts "You are a dashing, rugged adventurer."
  end

  def look
    list("You can see", ["a lightning bug", "a guttering candle"])
  end

  def listen
    list("You hear", ["a distant waterfall"])
  end

  def smell
    list("You smell", ["egg salad"])
  end

  def observe
    look
    listen
    smell
  end

  def list(prefix, objects)
    objects.each do |o|
      io.puts "#{prefix} #{o}."
    end
  end

  def io
    @io || $stdout
  end
  attr_writer :io
end

require 'delegate'

class BowlerHatDecorator < SimpleDelegator
  def describe
    super
    io.puts "A jaunty bowler cap sits atop your head."
  end
end

class InfravisionPotionDecorator < SimpleDelegator
  def describe
    super
    io.puts "Your eyes glow dull red."
  end

  def look
    super
    look_infrared
  end

  def look_infrared
    list("You can see", ["the ravenous bugblatter beast of traal"])
  end
end

