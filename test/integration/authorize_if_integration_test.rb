require 'test_helper'

class AuthorizeIfIntegrationTest < ActionDispatch::IntegrationTest
  test "authorized if true is given" do
    get show_authorized_path
    assert_equal 200, response.status
  end

  test "unauthorized if false is given" do
    assert_raises(AuthorizeIf::NotAuthorizedError) { get show_unauthorized_path }
  end
end
