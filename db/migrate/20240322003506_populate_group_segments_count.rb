class PopulateGroupSegmentsCount < ActiveRecord::Migration[7.1]
  def change
    Group.all.each do |group|
      Group.reset_counters(group.id, :segments)
    end
  end
end
