class DraperController < ApplicationController
  def index
    @widgets = Widget.make_me(5).map(&:decorate)
  end
end
