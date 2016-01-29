require 'test_helper'
require 'minitest/autorun'

class DummyClass
  include AuthorizeIf

  def params
    { action: "index" }
  end
end

class AuthorizeIfUnitTest < ActiveSupport::TestCase
  describe AuthorizeIf do
    before do
      @instance = DummyClass.new
    end

    describe "#authorize_if" do
      describe "when object is given" do
        it "returns true if truthy object is given" do
          assert_equal true, @instance.authorize_if(true)
          assert_equal true, @instance.authorize_if(Object.new)
        end

        it "raises NotAuthorizedError if falsey object is given" do
          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @instance.authorize_if(false)
          end

          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @instance.authorize_if(a = nil)
          end
        end

        describe "when message is given" do
          it "raises exception with given message" do
            err = assert_raises(AuthorizeIf::NotAuthorizedError) do
              @instance.authorize_if(false, message: "Custom Message")
            end
            assert_match /\ACustom Message\z/, err.message
          end
        end
      end

      it "raises ArgumentError if no arguments given" do
        assert_raises(ArgumentError) do
          @instance.authorize_if
        end
      end
    end

    describe "#authorize" do
      describe "when corresponding rule does exist" do
        describe "without parameters" do
          it "returns true if rule returns true" do
            instance = @instance.dup
            instance.define_singleton_method :authorize_index? do true; end
            assert_equal true, instance.authorize
          end
        end

        describe "with parameters" do
          it "calls rule with given parameters" do
            instance = @instance.dup
            class << instance
              def authorize_index?(param_1, param_2:)
                param_1 || param_2
              end
            end

            assert_equal(
              true,
              instance.authorize(false, param_2: true)
            )
          end

        end
      end

      describe "when method, corresponding to caller, does not exist" do
        it "raises NotAuthorizedError" do
          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @instance.authorize
          end
        end
      end
    end
  end
end
