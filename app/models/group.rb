class Group < ApplicationRecord
  has_many :segments, dependent: :destroy

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
