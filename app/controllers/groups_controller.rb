class GroupsController < ApplicationController
  before_action :set_group

  def next
    previous_value = []
    rollback = false
    now = Time.now.to_date
    @group.segments.order(position: :asc).each do |segment|
      previous_value.push(segment.value)
      next_segment = NextSegmentsService.call(segment, now)

      if next_segment.success?
        if next_segment.result
          segment.update(value: next_segment.result)
        end
      else
        case next_segment.errors.first[1]
        when "reset"
          segment.reset_value
        when "rollback"
          rollback = true
        when "unchanged"
          nil
        else
          flash[:alert] = next_segment.errors.first[1]
        end
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
