require 'spec_helper'

describe Api::FoldersController do
  render_views

  let!(:user) { create(:user) }
  let(:folder) { create(:folder, parent_id: user.root_folder.id) }
  let!(:folder_attributes) { [:id, :name, :created_at, :updated_at] }

  describe "creating a folder" do

    it "should fail with invalid name" do
      api_post :create, folder: { name: folder.name, parent_id: user.root_folder.id }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should fail wiht invalid parent" do
      api_post :create, folder: { name: 'test', parent_nil: nil }
      expect(json_response['errors'].keys).to eq(['parent'])
      assert_invalid_record!
    end

    it "should return 404 error if parent could not be found" do
      api_post :create, folder: { name: 'test', parent_id: -1}
      assert_not_found!
    end

    it "should create a new folder in root folder" do
      api_post :create, folder: { name: 'test', parent_id: 0 }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(user.root_folder.descendants.count).to eq(1)
    end

    it "should create a sibling in parent folder" do
      api_post :create, folder: { name: 'test', parent_id: folder.id }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(Folder.all.last.root?).to eq(false)
    end
  end
end
