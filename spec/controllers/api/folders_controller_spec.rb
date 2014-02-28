require 'spec_helper'

describe Api::FoldersController do
  render_views

  let!(:folder) {
    current_user.folders.create(name: 'test', parent_id: current_user.root_folder.id)
  }
  let!(:folder_attributes) { [:id, :name, :created_at, :updated_at] }
  let!(:item_attributes) { [:id, :name, :type] }

  describe "indexing a folder" do
    it "should return 404 error if folder could not be found" do
      api_get :index, id: -1
      assert_not_found!
    end

    it "should get all items" do
      create(:file_item, folder: current_user.root_folder)
      api_get :index, id: 0
      expect(response.status).to eq(200)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to have_attributes(item_attributes)
      expect(json_response.first['type']).to eq('folder')
      expect(json_response.last['type']).to eq('file')
    end
  end

  describe "showing folder" do
    it "should return 404 error if folder could not be found" do
      api_get :show, id: -1
      assert_not_found!
    end

    it "should return informations" do
      api_get :show, id: current_user.root_folder.id
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(folder_attributes)
    end
  end

  describe "creating a folder" do
    it "should fail with invalid name" do
      api_post :create,
        folder: {
          name: folder.name,
          parent_id: current_user.root_folder.id
        }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should fail wiht invalid parent" do
      api_post :create, folder: { name: 'test', parent_id: nil }
      expect(json_response['errors'].keys).to eq(['parent_id'])
      assert_invalid_record!
    end

    it "should return 404 error if parent could not be found" do
      api_post :create, folder: { name: 'test', parent_id: -1}
      assert_not_found!
    end

    it "should create a new folder in root folder" do
      expect{
        api_post :create, folder: { name: 'new', parent_id: 0 }
      }.to change{ current_user.root_folder.children.count }.by(1)
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
    end

    it "should create a folder in parent folder" do
      api_post :create, folder: { name: 'test', parent_id: folder.id }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(Folder.all.last.root?).to eq(false)
    end
  end

  describe "updating a folder" do
    it "should return 404 error if folder could not be found" do
      api_put :update, id: -1
      assert_not_found!
    end

    it "should fail with invalid attributes" do
      f = current_user.folders.create(name: 'new', parent_id: current_user.root_folder.id)
      api_put :update, id: folder.id, folder: { name: f.name }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should fail if destination folder not found" do
      api_put :update, id: folder.id, folder: { parent_id: -1 }
      assert_not_found!
    end

    it "should return 403 error for the root folder" do
      api_put :update, id: 0, folder: { name: 'test', parent_id: folder.id }
      assert_forbidden_operation!
    end

    it "should change the name" do
      api_put :update, id: folder.id, folder: { name: 'rename' }
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(folder_attributes)
      expect(json_response['name']).to eq('rename')
    end

    it "should move the folder" do
      f = current_user.folders.create(name: 'new', parent_id: current_user.root_folder.id)
      expect{
        api_put :update, id: folder.id, folder: { parent_id: f.id }
      }.not_to change{Folder.count}.by(1)
      expect(response.status).to eq(200)
      expect(f.children.last).to eq(folder)
    end

    it "should move the folder to the root" do
      f = current_user.folders.create(name: 'new', parent_id: folder.id)
      expect{
        api_put :update, id: f.id, folder: { parent_id: 0 }
      }.not_to change{Folder.count}.by(1)
      expect(response.status).to eq(200)
      expect(current_user.root_folder.children.last).to eq(f)
    end
  end

  describe "deleting  folder" do
    it "should return 404 error if folder could not be found" do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    it "should return 403 forbidden operation for root folder" do
      api_delete :destroy, id: 0
      assert_forbidden_operation!
    end

    it "should delete folder and his descendants" do
      folder.children.create(name: 'test')
      expect{
        api_delete :destroy, id: folder.id
      }.to change{Folder.count}.by(-2)
      expect(response.status).to eq(204)
    end
  end
end
