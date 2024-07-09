class NextGroupsService
  # Given a "Group" object and a date as parameters,
  # it increases the group's counter by one according to
  # its segments' behavior and reset configuration
  # considering the specified date.
  #
  # If it succeeds, it returns the group's new value.
  prepend SimpleCommand

  def initialize(group, now)
    @group = group
    @now = now
  end

  def call
    ActiveRecord::Base.transaction do
      @group.segments.order(position: :asc).each do |segment|
        # Checks the selected segment's next value calling NextSegmentValue.
        next_segment = NextSegmentsService.call(segment, @now)

        if next_segment.success?
          if next_segment.result
            segment.update(value: next_segment.result, date: @now.strftime("%Y-%m-%d"))
          end
        else
          case next_segment.errors.first[1]
          # The segment's value resets to its base value. 
          when "reset"
            segment.reset_value
            segment.update(date: @now.strftime("%Y-%m-%d"))
          # The transaction is rolled back, the counter doesn't change
          when "rollback"
            errors.add(:base, "Error: Se alcanzó el límite del contador")
            raise ActiveRecord::Rollback
          # The segment doesn't change
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
