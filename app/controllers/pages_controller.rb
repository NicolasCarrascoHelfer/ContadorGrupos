class PagesController < ApplicationController
  before_action :update_time

  def home
  end

  def count
    @group = Group.first
    @groupvalue = ""
    @group.segments.order(order: :desc).each do |segment|
      @groupvalue.concat(segment.value)
    end
  end

  private

  def update_time
    
  end
end
