require 'test_helper'
require 'minitest/autorun'

class DummyController
  include AuthorizeIf

  def controller_name
    "dummy"
  end

  def action_name
    "index"
  end
end

class AuthorizeIfUnitTest < ActiveSupport::TestCase
  describe AuthorizeIf do
    describe "#authorize_if" do
      before do
        @controller = DummyController.new
      end

      describe "when object is given" do
        it "returns true if truthy object is given" do
          assert_equal true, @controller.authorize_if(true)
          assert_equal true, @controller.authorize_if(Object.new)
        end

        it "raises NotAuthorizedError if falsey object is given" do
          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @controller.authorize_if(false)
          end

          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @controller.authorize_if(a = nil)
          end
        end
      end

      describe "when block is given" do
        it "raises exception with message set through block" do
          err = assert_raises(AuthorizeIf::NotAuthorizedError) do
            @controller.authorize_if(false) do |config|
              config.error_message = "Custom Message"
            end
          end
          assert_equal "Custom Message", err.message
        end
      end

      it "raises ArgumentError if no arguments given" do
        assert_raises(ArgumentError) do
          @controller.authorize_if
        end
      end
    end

    describe "#authorize" do
      before do
        @controller = DummyController.new
      end

      describe "when corresponding rule does exist" do
        describe "without parameters" do
          it "returns true if rule returns true" do
            @controller.define_singleton_method :authorize_index? do true; end
            assert_equal true, @controller.authorize
          end
        end

        describe "with parameters" do
          it "calls rule with given parameters" do
            class << @controller
              def authorize_index?(param_1, param_2:)
                param_1 || param_2
              end
            end

            assert_equal(
              true,
              @controller.authorize(false, param_2: true)
            )
          end
        end

        describe "when block is given" do
          it "raises exception with message set through block" do
            err = assert_raises(AuthorizeIf::NotAuthorizedError) do
              @controller.define_singleton_method :authorize_index? do false; end
              @controller.authorize do |config|
                config.error_message = "Custom Message"
              end
            end
            assert_equal "Custom Message", err.message
          end
        end
      end

      describe "when method, corresponding to caller, does not exist" do
        it "raises NotAuthorizedError" do
          err = assert_raises(AuthorizeIf::MissingAuthorizationRuleError) do
            @controller.authorize
          end
          msg = "No authorization rule defined for action dummy#index. Please define method #authorize_index? for #{@controller.class.name}"
          assert_equal msg, err.message
        end
      end
    end
  end
end
