class Segment < ApplicationRecord
  belongs_to :group, counter_cache: true

  def reset_value
    self.update(value: self.base_value)
  end
end
