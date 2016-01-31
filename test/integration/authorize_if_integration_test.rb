require 'test_helper'

class AuthorizeIfIntegrationTest < ActionDispatch::IntegrationTest
  begin # `index` action where `authorize_if` is used
    test "index action is authorized if true is given" do
      get "/articles", { authorized: true }
      assert_equal 200, response.status
    end

    test "index action renders custom error if false is given" do
      error_message = "Custom #{rand(100)} error message"

      get "/articles", { error_message: error_message }
      assert_equal 403, response.status
      assert_equal error_message, response.body
    end
  end

  begin # `show` action where `authorize` is used
    test "show action is authorized if true is given" do
      get "/articles/1", { authorized: true }
      assert_equal 200, response.status
    end

    test "show action renders custom error if false is given" do
      error_message = "Custom #{rand(100)} error message"

      get "/articles/1", { error_message: error_message }
      assert_equal 403, response.status
      assert_equal error_message, response.body
    end
  end

  begin # `edit` action where `authorize` is used
    test "edit action renders Internal Server Error if authorization rule is not defined" do
      get "/articles/1/edit"
      assert_equal 500, response.status
      raise "#{response.body}"
      assert_match /authorize_edit/, response.body
    end
  end
end
