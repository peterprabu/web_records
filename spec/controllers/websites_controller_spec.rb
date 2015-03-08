require 'rails_helper'

RSpec.describe WebsitesController, type: :controller do

let(:web) { WebsitesController.new }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #display" do
    it "returns http success" do
      get :display
      expect(response).to have_http_status(:success)
    end
  end

end
