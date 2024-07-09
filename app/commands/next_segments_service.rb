class NextSegmentsService
  # Given a "Segment" object and a date as parameters,
  # it checks if the segment's value will increase
  # if the counter increases considering the specified
  # date.
  #
  # If it succeeds, it returns the segment's new value.
  #
  # If it fails, it returns the reason as an error message.
  prepend SimpleCommand

  def initialize(segment, now)
    @segment = segment
    @now = now
  end

  def call
    if @segment.alpha? && @segment.correlative?
      next_value = @segment.value.next
      updated = @segment.date.in_time_zone("America/Lima").to_date
      # Checks if at least a day passed since last update and if the segment can reset.
      if updated != @now && !(@segment.never?)
        # Checks if the time passed since the last segment's update makes the segment reset to its base value.
        if (@now.year != updated.year && (@segment.year? || @segment.month? || @segment.day?)) || (@now.month != updated.month && (@segment.month? || @segment.day?)) || (@now.day != updated.day && @segment.day?)
          errors.add(:base, "reset")
        else
          return next_value
        end
      # Checks if the next value for the segment doesn't exceed the character limit.
      elsif next_value.size <= @segment.base_value.size
        return next_value
      else
        errors.add(:base, "rollback")
      end
    elsif @segment.date? && @segment.system? && @now != @segment.value.to_date
      return @now.strftime("%Y-%m-%d")
    else
      errors.add(:base, "unchanged")
    end
  end
end
