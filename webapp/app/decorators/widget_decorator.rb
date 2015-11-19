class WidgetDecorator < Draper::Decorator
  decorates :widget
  delegate :id, :name, :price, :percent_off # necessary for non-AR models?

  def price
    "$#{object.price}"
  end

  def name
    object.name.upcase
  end

  def percent_off
    object.percent_off ? "%#{(object.percent_off * 100).round}" : nil
  end
end
