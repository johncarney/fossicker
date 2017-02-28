require "spec_helper"

RSpec.describe Fossicker do
  it "has a version number" do
    expect(Fossicker::VERSION).not_to be nil
  end

  describe ".fossick" do
    let(:paydirt) { double :paydirt }
    let(:default) { double :default }

    context "given a nested hash" do
      it "returns the nested value" do
        object = { a: { b: { c: paydirt } } }
        expect(described_class.fossick(object, :a, :b, :c)).to be paydirt
      end
    end

    context "given a nested array" do
      it "returns the nested value" do
        object = [ [], [ paydirt, [] ] ]
        expect(described_class.fossick(object, 1, 0)).to be paydirt
      end
    end

    context "given a mix of hashes and arrays" do
      it "returns the nested value" do
        object = { a: [ [], [ { b: paydirt }, [] ] ] }
        expect(described_class.fossick(object, :a, 1, 0, :b)).to be paydirt
      end
    end

    context "without a default or block" do
      context "when a key does not exist" do
        context "for a hash" do
          it "raises a KeyError" do
            object = { a: {} }
            expect { described_class.fossick(object, :a, :b) }.to raise_exception KeyError
          end
        end

        context "for an array" do
          it "raises an IndexError" do
            object = [ nil, [] ]
            expect { described_class.fossick(object, 1, 0) }.to raise_exception IndexError
          end
        end
      end
    end

    context "given a default value" do
      context "when a key does not exist" do
        it "returns the default value" do
          object  = { a: {} }
          expect(described_class.fossick(object, :a, :b, default: default)).to be default
        end
      end

      context "when all keys exist" do
        it "returns the keyed value" do
          object = { a: { b: paydirt } }
          expect(described_class.fossick(object, :a, :b, default: default)).to be paydirt
        end
      end
    end

    # NB: This test is useful because in an earlier implementation if you specified a nil default value
    #     it would behave as if you had not specified a default.
    context "given a default value of nil" do
      context "when a key does not exist" do
        it "returns nil" do
          object  = { a: {} }
          expect(described_class.fossick(object, :a, :b, default: nil)).to be_nil
        end
      end
    end

    context "given a block" do
      context "when a key does not exist" do
        it "invokes the block with the key" do
          object = { a: {} }
          expect { |b| described_class.fossick(object, :a, :b, &b)}.to yield_with_args(:b)
        end

        it "returns the block result" do
          object  = { a: {} }
          expect(described_class.fossick(object, :a, :b) { default }).to be default
        end
      end

      context "when all keys exist" do
        it "does not invoke the block" do
          object = { a: { b: 1 } }
          expect { |b| described_class.fossick(object, :a, :b, &b)}.to_not yield_control
        end

        it "returns the keyed value" do
          object = { a: { b: paydirt } }
          expect(described_class.fossick(object, :a, :b) { :default }).to be paydirt
        end
      end
    end

    it "does not try fossick into the default value" do
      object  = {}
      expect(default).to_not receive(:fetch)
      described_class.fossick(object, :a, :b, default: default)
    end
  end
end
