class AddSegmentCounterCacheToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :segments_count, :integer
  end
end
