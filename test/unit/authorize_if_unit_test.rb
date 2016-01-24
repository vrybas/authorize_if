require 'test_helper'
require 'minitest/autorun'

class DummyClass
  include AuthorizeIf
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

        it "raises NotAuthorizedError if no arguments given" do
          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @instance.authorize_if
          end
        end
      end

      describe "when block is given" do
        it "returns true if block evaluates to truthy" do
          assert_equal true, @instance.authorize_if { true }
          assert_equal true, @instance.authorize_if { Object.new }
        end

        it "raises NotAuthorizedError if block evaluates to falsey" do
          assert_raises(AuthorizeIf::NotAuthorizedError) do
            @instance.authorize_if { false }
            @instance.authorize_if { a = nil }
          end
        end

        it "passes calling context as block argument" do
          @instance.define_singleton_method :params do
            { a: true }
          end

          assert_equal(
            true,
            @instance.authorize_if do |context|
              context.params[:a]
            end
          )
        end
      end

      describe "when both object and block are given" do
        it "then block serves as fallback to a given object, if object evaluates to falsey" do
          record = Object.new
          record.define_singleton_method :published do
            false
          end

          assert_equal(
            true,
            @instance.authorize_if(record.published) do
              true
            end
          )
        end
      end
    end
  end
end
