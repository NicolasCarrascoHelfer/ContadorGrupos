require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
   test "AAA01 to AAA02" do 
     seg1 = Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "day", position: 1, group: testgroup)
     seg2 = Segment.create(category: "alpha", base_value: "01", value: "01", behavior: "correlative", reset: "day", position: 1, group: testgroup)
     service = NextNum.call([seg1, seg2])
     assert_equal "AA02", service.result

   end
end
