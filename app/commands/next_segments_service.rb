class NextSegmentsService
  prepend SimpleCommand

  def initialize(segment, now)
    @segment = segment
    @now = now
  end

  def call
    if @segment.alpha? && @segment.correlative?
      next_value = @segment.value.next
      updated = @segment.updated_at.in_time_zone("America/Lima").to_date
      if updated != @now && !(@segment.never?)
        if (@now.year != updated.year && @segment.year?) || (@now.month != updated.month && @segment.month?) || (@now.day != updated.day && @segment.day?)
          return "reset"
        else
          return next_value
        end
      elsif next_value.size <= @segment.base_value.size
        return next_value
      else
        errors.add(:base, :failure)
      end
    end

    if @segment.date? && @segment.system? && @now != @segment.value.to_date
      return @now.strftime("%Y-%m-%d")
    end

  end
end
