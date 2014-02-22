require 'spec_helper'

describe Api::FoldersController do
  render_views

  let!(:folder) { create(:folder) }
  let!(:folder_attributes) { [:id, :name, :created_at, :updated_at] }

  describe "creating a folder" do

    it "should fail with invalid name" do
      api_post :create, folder: { name: folder.name }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should create a root folder" do
      api_post :create, folder: { name: 'test' }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(Folder.all.last.root?).to eq(true)
    end

    it "should create a sibling in parent folder" do
      api_post :create, folder: { name: 'test', parent_id: folder.id }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(Folder.all.last.root?).to eq(false)
    end
  end
end
