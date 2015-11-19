class Widget
  include ActiveModel::Model
  include Draper::Decoratable

  attr_accessor :id, :name, :price, :percent_off

  def price
    (@price * (percent_off || 1)).round(2)
  end

  def self.make_me(number)
    number.times.map do |i|
      Widget.new(
        id: i+1,
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price
      )
    end.tap do |widgets|
      widgets.sample.percent_off = rand.round(2)
    end
  end
end
