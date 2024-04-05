class GroupsController < ApplicationController
  before_action :set_group

  def next
    previous_value = []
    rollback = false
    now = Time.now.to_date
    @group.segments.order(position: :asc).each do |segment|
      previous_value.push(segment.value)

      if segment.alpha? && segment.correlative?
        next_value = segment.value.next
        updated = segment.updated_at.to_date
        if updated != now && !(segment.never?)
          if (now.year != updated.year && segment.year?) || (now.month != updated.month && segment.month?) || (now.day != updated.day && segment.day?)
            segment.reset_value
          end
        elsif next_value == segment.base_value || next_value.size > segment.base_value.size
          rollback = true
        else
          segment.update(value: next_value)
        end
      end

      if segment.date? && segment.system? && now != segment.value.to_date
        segment.update(value: now.strftime("%Y-%m-%d"))
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

  def reset
    @group.segments.order(position: :desc).each do |segment|
      segment.reset_value
    end
    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
