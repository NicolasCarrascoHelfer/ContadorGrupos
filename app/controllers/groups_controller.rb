class GroupsController < ApplicationController
  before_action :set_group

  def next
    now = Time.now.to_date

    next_group = NextGroupsService.call(@group, now)

    if !next_group.success?
      flash[:alert] = next_group.errors.first[1]
    end

    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
