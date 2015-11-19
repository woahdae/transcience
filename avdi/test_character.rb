require_relative 'testing_helper'

require_relative 'character'

class TestCharacter < MiniTest::Test
  def setup
    @character = Character.new.tap {|c| c.io = StringIO.new}
  end

  def test_character_does_basic_stuff
    @character.describe
    @character.look
    @character.listen

    assert_equal <<-STR.unindent, read_io(@character.io)
      You are a dashing, rugged adventurer.
      You can see a lightning bug.
      You can see a guttering candle.
      You hear a distant waterfall.
    STR
  end

  def test_character_observation
    @character.observe

    assert_equal <<-STR.unindent, read_io(@character.io)
      You can see a lightning bug.
      You can see a guttering candle.
      You hear a distant waterfall.
      You smell egg salad.
    STR
  end

  def test_bowler_hat_description
    @character = BowlerHatDecorator.new(@character)
    @character.describe

    assert_equal <<-STR.unindent, read_io(@character.io)
      You are a dashing, rugged adventurer.
      A jaunty bowler cap sits atop your head.
    STR
  end

  def test_infravision_potion_does_basic_stuff
    @character = InfravisionPotionDecorator.new(@character)
    @character.describe
    @character.look

    assert_equal <<-STR.unindent, read_io(@character.io)
      You are a dashing, rugged adventurer.
      Your eyes glow dull red.
      You can see a lightning bug.
      You can see a guttering candle.
      You can see the ravenous bugblatter beast of traal.
    STR
  end

  # this one will fail, since Character#observe calls Character#look,
  # rather than the expected InfravisionPotionDecorator#look
  def test_infravision_potion_with_observation
    @character = InfravisionPotionDecorator.new(@character)
    @character.observe

    assert_equal <<-STR.unindent, read_io(@character.io)
      You can see a lightning bug.
      You can see a guttering candle.
      You can see the ravenous bugblatter beast of traal.
      You hear a distant waterfall.
      You smell egg salad.
    STR
  end

  def read_io(io)
    io.tap(&:rewind).read
  end
end
