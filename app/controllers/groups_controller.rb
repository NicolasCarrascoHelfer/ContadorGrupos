class GroupsController < ApplicationController
  before_action :set_group

  def next
    previous_value = []
    rollback = false
    now = Time.now.to_date
    @group.segments.order(position: :asc).each do |segment|
      previous_value.push(segment.value)
      command = NextSegmentsService.call(segment, now)

      if command.success?
        if command.result == "reset"
          segment.reset_value
        elsif command.result
          segment.update(value: command.result)
        end
      else
        rollback = true
      end
    end

    if rollback
      flash[:alert] = "Error: Se alcanzó el límite del contador"
      count = 0
      @group.segments.order(position: :asc).each do |segment|
        segment.update(value: previous_value[count])
        count = count + 1
      end
    end
    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
