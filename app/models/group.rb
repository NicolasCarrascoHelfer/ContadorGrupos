class Group < ApplicationRecord
    has_many :segments, dependent: :destroy
end
