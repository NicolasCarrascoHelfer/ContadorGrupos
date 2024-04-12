describe NextSegmentsService do
  subject(:context) { described_class.call(segment, now) }

  describe ".call" do
    context "when the context is successful" do
      segment = nil
      now = nil
      let(:segment) { segment }
      let(:now) { now }

      it "succeeds" do
        expect(context).to be_success
      end
    end

    context "when the context is not successful" do
      segment = nil
      now = nil
      let(:segment) { segment }
      let(:now) { now }

      it "fails" do
        expect(context).to be_failure
      end
    end
  end
end
