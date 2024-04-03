class Group < ApplicationRecord
  has_many :segments, dependent: :destroy

  def next_value
    add = true
    previous_value = []
    rollback = false
    self.segments.order(position: :desc).each do |segment|
      previous_value.push(segment.value)
      if segment.date? && segment.system? && Time.now.to_date != segment.value.to_date
        now = Time.now.to_date
        value = segment.value.to_date
        if now.year != value.to_date.year
          self.reset("d")
          self.reset("m")
          self.reset("y")
        elsif now.month != value.to_date.month
          self.reset("d")
          self.reset("m")
        elsif now.day != value.to_date.day
          self.reset("d")
        end
        segment.update(value: Time.now.strftime("%Y-%m-%d"))
      end

      if add && segment.alpha? && segment.correlative?
        if segment.value.next == segment.base_value || segment.value.next.size > segment.base_value.size
          rollback = true
        else
          segment.update(value: segment.value.next)
          add = false
        end
      end
    end
    if rollback
      @notice = true
      count = 0
      self.segments.order(position: :desc).each do |segment|
        segment.update(value: previous_value[count])
        count = count + 1
      end
    end
  end

  def reset(option)
    self.segments.each do |segment|
      case option
      when "d"
        if segment.day?
          segment.reset_value
        end
      when "m"
        if segment.month?
          segment.reset_value
        end
      when "y"
        if segment.year?
          segment.reset_value
        end
      end
    end
  end

  def value
    groupval = ""
    self.segments.order(position: :asc).each do |segment|
      if segment.date?
        segment.format.each_char do |character|
          groupval.concat(segment.value.to_date.strftime("%#{character}"))
        end
      else
        groupval.concat(segment.value)
      end
    end
    return groupval
  end
end
