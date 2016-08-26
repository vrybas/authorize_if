RSpec.describe AuthorizeIf do
  let(:controller) {
    double(:dummy_controller, controller_name: "dummy", action_name: "index").
    extend(AuthorizeIf)
  }

  describe "#authorize_if" do
    context "when object is given" do
      it "returns true if truthy object is given" do
        expect(controller.authorize_if(true)).to eq true
        expect(controller.authorize_if(Object.new)).to eq true
      end

      it "raises NotAuthorizedError if falsey object is given" do
        expect {
          controller.authorize_if(false)
        }.to raise_error(AuthorizeIf::NotAuthorizedError)

        expect {
          controller.authorize_if(nil)
        }.to raise_error(AuthorizeIf::NotAuthorizedError)
      end
    end

    context "when object and block are given" do
      it "allows exception customization through the block" do
        expect {
          controller.authorize_if(false) do |exception|
            exception.message = "Custom Message"
            exception.context[:request_ip] = "192.168.1.1"
          end
        }.to raise_error(AuthorizeIf::NotAuthorizedError, "Custom Message") do |exception|
          expect(exception.message).to eq("Custom Message")
          expect(exception.context[:request_ip]).to eq("192.168.1.1")
        end
      end
    end

    context "when no arguments are given" do
      it "raises ArgumentError" do
        expect {
          controller.authorize_if
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#authorize" do
    context "when corresponding authorization rule exists" do
      context "when rule does not accept parameters" do
        it "returns true if rule returns true" do
          controller.define_singleton_method(:authorize_index?) { true }
          expect(controller.authorize).to eq true
        end
      end

      context "when rule accepts parameters" do
        it "calls rule with given parameters" do
          class << controller
            def authorize_index?(param_1, param_2:)
              param_1 || param_2
            end
          end

          expect(controller.authorize(false, param_2: true)).to eq true
        end
      end

      context "when block is given" do
        it "passes block through to `authorize_if` method" do
          controller.define_singleton_method(:authorize_index?) { false }

          expect {
            controller.authorize do |exception|
              exception.message = "passed through"
            end
          }.to raise_error(AuthorizeIf::NotAuthorizedError, "passed through") do |exception|
            expect(exception.message).to eq("passed through")
          end
        end
      end
    end

    context "when corresponding authorization rule does not exist" do
      it "raises MissingAuthorizationRuleError" do
        expect {
          controller.authorize
        }.to raise_error(
          AuthorizeIf::MissingAuthorizationRuleError,
          "No authorization rule defined for action dummy#index. Please define method #authorize_index? for #{controller.class.name}"
        )
      end
    end
  end
end
