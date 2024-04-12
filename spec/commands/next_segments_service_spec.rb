require "rails_helper"
describe NextSegmentsService do
  subject(:context) { described_class.call(segment, now) }
  group = Group.create(name: "Testgroup")

  describe ".call" do
    context "AAA to AAB" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "succeeds" do
        expect(context).to be_success
      end
    end

    context "ZZZ fails" do
      segment = Segment.create(category: "alpha", base_value: "ZZZ", value: "ZZZ", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
    end

    context "ZZZ to AAA because reset day" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "ZZZ", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.next_day.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "succeeds" do
        expect(context.result).to eq("reset")
      end
    end
  end
end
