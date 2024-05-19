class GroupsController < ApplicationController
  before_action :set_group

  def next
    previous_value = []
    rollback = false
    now = Time.now.to_date

    ActiveRecord::Base.transaction do
      @group.segments.order(position: :asc).each do |segment|
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
            flash[:alert] = "Error: Se alcanzó el límite del contador"
            raise ActiveRecord::Rollback
          when "unchanged"
            nil
          else
            flash[:alert] = next_segment.errors.first[1]
          end
        end
      end
    end
    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
