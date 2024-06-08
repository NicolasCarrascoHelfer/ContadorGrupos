require "rails_helper"
describe NextGroupsService do
  subject(:context) { described_class.call(group, now) }

  describe ".call" do
    context "Next to AAA202012121Z" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "date", format: "Ymd", base_value: "20201212", value: "20201212", behavior: "system", reset: "never", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "1A", value: "1Z", behavior: "correlative", reset: "never", position: 3, group: testgroup)
      now = Time.now.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns AAB(today)2A" do
        expect(context.result).to eq("AAB#{Time.now.to_date.strftime("%Y%m%d")}2A")
      end
    end

    context "Next to ZZZ2343B1" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "ABC", value: "ZZZ", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "alpha", base_value: "11", value: "23", behavior: "correlative", reset: "never", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "11", value: "43", behavior: "correlative", reset: "never", position: 3, group: testgroup)
      Segment.create(category: "alpha", base_value: "A", value: "B", behavior: "correlative", reset: "never", position: 4, group: testgroup)
      Segment.create(category: "alpha", base_value: "1", value: "1", behavior: "correlative", reset: "never", position: 5, group: testgroup)
      now = Time.now.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end

      it "error límite" do
        expect(context.errors.first[1]).to eq("Error: Se alcanzó el límite del contador")
      end
    end

    context "Next to ABCZ2349Z1 after 1 month" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "ABCI", value: "ABCZ", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "alpha", base_value: "11", value: "23", behavior: "correlative", reset: "never", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "11", value: "49", behavior: "correlative", reset: "never", position: 3, group: testgroup)
      Segment.create(category: "alpha", base_value: "X", value: "Z", behavior: "correlative", reset: "day", position: 4, group: testgroup)
      Segment.create(category: "alpha", base_value: "1", value: "1", behavior: "constant", reset: "never", position: 5, group: testgroup)
      now = Time.now.next_month.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns ABDA2450X1" do
        expect(context.result).to eq("ABDA2450X1")
      end
    end

    context "Next to AAA202012121A" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "date", format: "Ymd", base_value: "20201212", value: "20201212", behavior: "system", reset: "never", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "1A", value: "1A", behavior: "correlative", reset: "never", position: 3, group: testgroup)
      now = Time.now.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns AAB(today)1B" do
        expect(context.result).to eq("AAB#{Time.now.to_date.strftime("%Y%m%d")}1B")
      end
    end

    context "Next to #." do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "#", value: "#", behavior: "constant", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "alpha", base_value: ".", value: ".", behavior: "constant", reset: "never", position: 2, group: testgroup)
      now = Time.now.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns #." do
        expect(context.result).to eq("#.")
      end
    end

    context "Next to 20ZZ11 after 1 day" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "11", value: "20", behavior: "correlative", reset: "never", position: 1, group: testgroup)
      Segment.create(category: "alpha", base_value: "AA", value: "ZZ", behavior: "correlative", reset: "day", position: 2, group: testgroup)
      Segment.create(category: "alpha", base_value: "11", value: "11", behavior: "correlative", reset: "never", position: 2, group: testgroup)
      now = Time.now.next_day.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns 21AA12" do
        expect(context.result).to eq("21AA12")
      end
    end

    context "Next to 1" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "1", value: "1", behavior: "correlative", reset: "day", position: 1, group: testgroup)
      now = Time.now.next_day.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns 1" do
        expect(context.result).to eq("1")
      end
    end

    context "Next to 2" do
      testgroup = Group.create(name: "Testgroup")
      Segment.create(category: "alpha", base_value: "1", value: "2", behavior: "correlative", reset: "day", position: 1, group: testgroup)
      now = Time.now.next_day.to_date
      let(:group) { testgroup }
      let(:now) { now }

      it "success" do
        expect(context).to be_success
      end

      it "returns 1" do
        expect(context.result).to eq("1")
      end
    end
  end
end
