class Segment < ApplicationRecord
  belongs_to :group, counter_cache: true
end
