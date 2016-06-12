RSpec.describe ArticlesController, type: :request do
  describe "/articles" do
    describe "GET" do
      it "is authorized when current user is present" do
        allow_any_instance_of(described_class).
          to receive(:current_user).and_return(double(:user))

        get "/articles/index"
        expect(response.status).to eq(200)
      end

      it "is not authorized when current user is absent" do
        allow_any_instance_of(described_class).
          to receive(:current_user).and_return(false)

        get "/articles/index", { message: "Custom Message" }
        expect(response.status).to eq(403)
        expect(response.body).to eq("Custom Message")
      end
    end
  end
end
