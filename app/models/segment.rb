class Segment < ApplicationRecord
  belongs_to :group, counter_cache: true

  after_initialize :set_default_date

  enum category: [:alpha, :date]
  enum behavior: [:system, :correlative, :constant]
  enum reset: [:day, :month, :year, :never]

  def reset_value
    self.update(value: self.base_value)
  end

  private

  def set_default_date
    self.date = Time.now
  end
end
