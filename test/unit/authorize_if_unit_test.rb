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
      end

      it "raises ArgumentError if no arguments given" do
        assert_raises(ArgumentError) do
          @instance.authorize_if
        end
      end
    end

    describe "#authorize_if" do
      describe "without parameters" do
        describe "when method, corresponding to action, does exist" do
          it "returns true when method, corresponding to action, returns true" do
            instance = @instance.dup
            instance.define_singleton_method :authorize_index? do true; end
            assert_equal true, instance.authorize
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
end
