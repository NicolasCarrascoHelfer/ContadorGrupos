class NextGroupsService
  prepend SimpleCommand

  def initialize(group, now)
    @group = group
    @now = now
  end

  def call
    ActiveRecord::Base.transaction do
      @group.segments.order(position: :asc).each do |segment|
        next_segment = NextSegmentsService.call(segment, @now)

        if next_segment.success?
          if next_segment.result
            segment.update(value: next_segment.result, date: @now.strftime("%Y-%m-%d"))
          end
        else
          case next_segment.errors.first[1]
          when "reset"
            segment.reset_value
            segment.update(date: @now.strftime("%Y-%m-%d"))
          when "rollback"
            errors.add(:base, "Error: Se alcanzó el límite del contador")
            raise ActiveRecord::Rollback
          when "unchanged"
            segment.update(date: @now.strftime("%Y-%m-%d"))
          else
            segment.update(date: @now.strftime("%Y-%m-%d"))
            errors.add(:base, next_segment.errors.first[1])
          end
        end
      end
      return @group.value
    end
  end
end
