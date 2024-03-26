class PagesController < ApplicationController
  def home
  end

  def count
    @group = Group.first
    @groupvalue = ""
    @group.segments.order(order: :desc).each do |segment|
      @groupvalue.concat(segment.value)
    end
  end
end
