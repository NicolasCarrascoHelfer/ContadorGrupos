class GroupsController < ApplicationController
  before_action :set_group

  def next
    @group.next_value
    redirect_to @group
  end

  def reset
    @group.segments.order(order: :asc).each do |segment|
      segment.reset_value
    end
    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
