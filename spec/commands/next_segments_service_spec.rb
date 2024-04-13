require "rails_helper"
describe NextSegmentsService do
  subject(:context) { described_class.call(segment, now) }
  group = Group.create(name: "Testgroup")

  describe ".call" do
    context "Next to AAA" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns AAB" do
        expect(context.result).to eq("AAB")
      end
    end

    context "Next to ZZZ" do
      segment = Segment.create(category: "alpha", base_value: "ZZZ", value: "ZZZ", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error rollback" do
        expect(context.errors.first[1]).to eq("rollback")
      end
    end

    context "Next to ZZZ with reset day" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "ZZZ", behavior: "correlative", reset: "day", position: 1, group: group)
      now = Time.now.next_day.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error reset" do
        expect(context.errors.first[1]).to eq("reset")
      end
    end

    context "Next to today after 1 month and 1 day" do
      segment = Segment.create(category: "date", format: "dm", base_value: Time.now.strftime("%Y-%m-%d"), value: Time.now.strftime("%Y-%m-%d"), behavior: "system", reset: "never", position: 1, group: group)
      now = Time.now.next_month.next_day.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end
      it "returns today after 1 month and 1 day" do
        expect(context.result).to eq(Time.now.next_month.next_day.strftime("%Y-%m-%d"))
      end
    end

    context "Next to AAE after 1 year with reset month" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "AAE", behavior: "correlative", reset: "month", position: 1, group: group)
      now = Time.now.next_year.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error reset" do
        expect(context.errors.first[1]).to eq("reset")
      end
    end

    context "Next to AAE after 1 year with reset year" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "AAE", behavior: "correlative", reset: "year", position: 1, group: group)
      now = Time.now.next_year.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error reset" do
        expect(context.errors.first[1]).to eq("reset")
      end
    end

    context "Next to AAE with behavior constant" do
      segment = Segment.create(category: "alpha", base_value: "AAA", value: "AAE", behavior: "constant", reset: "year", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error unchanged" do
        expect(context.errors.first[1]).to eq("unchanged")
      end
    end

    context "Next to 2024-04-05" do
      segment = Segment.create(category: "date", format: "Ymd", base_value: "2024-04-05", value: "2024-04-05", behavior: "system", reset: "never", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end
      it "returns today" do
        expect(context.result).to eq(Time.now.strftime("%Y-%m-%d"))
      end
    end

    context "Next to 2024-04-05 with behavior constant" do
      segment = Segment.create(category: "date", format: "dm", base_value: "2024-04-05", value: "2024-04-05", behavior: "constant", reset: "never", position: 1, group: group)
      now = Time.now.to_date
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
      it "error unchanged" do
        expect(context.errors.first[1]).to eq("unchanged")
      end
    end
  end
end
