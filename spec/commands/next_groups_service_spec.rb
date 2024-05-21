require "rails_helper"
describe NextGroupsService do
    
  subject(:context) { described_class.call(group, now) }
  testgroup = Group.create(name: "Testgroup")

  describe ".call" do
    context "Next to AAA202012121Z" do
      Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "date", format: "Ymd", base_value: "20201212", value: "20201212", behavior: "system", reset: "never", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "1A", value: "1Z", behavior: "correlative", reset: "never", position: 3, group: testgroup)
      now = Time.now.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns AAB" do
        expect(context.result).to eq("AAB#{Time.now.to_date.strftime("%Y%m%d")}2A")
      end
    end
  end
end
