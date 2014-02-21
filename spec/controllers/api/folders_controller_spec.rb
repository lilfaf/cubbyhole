require 'spec_helper'

describe Api::FoldersController do
  render_views

  let!(:folder) { create(:folder) }
  let!(:folder_attributes) { [:id, :name, :created_at, :updated_at] }

  describe "creating a folder" do
    it "should create a root folder if no parent_id provided" do
      api_post :create, folder: { name: 'test' }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      # IS THIS REALLY ROOT?
    end

    it "should create a sibling in parent folder" do
    end
  end
end
