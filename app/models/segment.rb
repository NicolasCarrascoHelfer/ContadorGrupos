class Segment < ApplicationRecord
  belongs_to :group, counter_cache: true

  enum category: [:alpha, :date]
  enum behavior: [:system, :correlative]
  enum reset: [:day, :month, :year, :never]

  def reset_value
    self.update(value: self.base_value)
  end
end
