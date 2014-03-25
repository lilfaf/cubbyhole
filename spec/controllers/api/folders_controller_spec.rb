require 'spec_helper'

describe Api::FoldersController do
  render_views

  let(:item_attributes) { [:id, :name, :type] }
  let(:folder_attributes) { [:id, :name, :created_at, :updated_at] }

  describe "indexing a folder" do
    it "should return 404 error if folder not found" do
      api_get :index, id: -1
      assert_not_found!
    end

    it "should get root folders and items" do
      create(:folder, user: current_user)
      create(:file_item, user: current_user)
      api_get :index, id: 0
      expect(response.status).to eq(200)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to have_attributes(item_attributes)
    end

    it "should get folder content" do
      root = create(:folder, user: current_user)
      create(:folder, user: current_user, parent_id: root.id)
      create(:file_item, user: current_user, folder_id: root.id)
      api_get :index, id: root.id
      expect(response.status).to eq(200)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to have_attributes(item_attributes)
    end
  end

  describe "showing folder" do
    it "should return 404 error if folder not found" do
      api_get :show, id: -1
      assert_not_found!
    end

    it "should return folder infos" do
      folder = create(:folder, name: 'test', user: current_user)
      api_get :show, id: folder.id
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(folder_attributes)
    end
  end

  describe "creating a folder" do
    it "should fail with invalid name" do
      folder = create(:folder, user: current_user)
      api_post :create, folder: { name: folder.name }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should return 404 error if parent not found" do
      api_post :create, folder: { name: 'test', parent_id: -1}
      assert_not_found!
    end

    it "should create a new root folder" do
      expect{
        api_post :create, folder: { name: 'new', parent_id: 0 }
      }.to change{ current_user.folders.roots.count }.by(1)
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
    end

    it "should create a folder in parent folder" do
      folder = create(:folder, user: current_user)
      api_post :create, folder: { name: 'test', parent_id: folder.id }
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(folder_attributes)
      expect(current_user.folders.last.root?).to eq(false)
    end
  end

  describe "updating a folder" do
    it "should return 404 error if folder not found" do
      api_put :update, id: -1
      assert_not_found!
    end

    it "should fail with invalid attributes" do
      folder1 = create(:folder, user: current_user)
      folder2 = create(:folder, user: current_user)
      api_put :update, id: folder1.id, folder: { name: folder2.name }
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should fail if destination folder not found" do
      folder = create(:folder, user: current_user)
      api_put :update, id: folder.id, folder: { parent_id: -1 }
      assert_not_found!
    end

    it "should change the name" do
      folder = create(:folder, user: current_user)
      api_put :update, id: folder.id, folder: { name: 'newname' }
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(folder_attributes)
      expect(json_response['name']).to eq('newname')
    end

    it "should move the folder" do
      folder1 = create(:folder, user: current_user)
      folder2 = create(:folder, user: current_user)
      expect{
        api_put :update, id: folder2.id, folder: { parent_id: folder1.id }
      }.not_to change{ current_user.folders.count }
      expect(response.status).to eq(200)
      expect(folder1.children.last).to eq(folder2)
    end

    it "should move the folder to the root" do
      folder1 = create(:folder, user: current_user)
      folder2 = create(:folder, user: current_user)
      expect{
        api_put :update, id: folder2.id, folder: { parent_id: 0 }
      }.not_to change{ current_user.folders.count }.by(1)
      expect(response.status).to eq(200)
      expect(current_user.folders.roots.last).to eq(folder2)
    end
  end

  describe "deleting  folder" do
    it "should return 404 error if folder not found" do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    it "should delete folder and his descendants" do
      folder = create(:folder, user: current_user)
      expect{
        api_delete :destroy, id: folder.id
      }.to change{ Folder.count }.by(-1)
      expect(response.status).to eq(204)
    end
  end

  describe "copying a folder" do
    it "should return 404 error if folder not found" do
      api_post :copy, id: -1
      assert_not_found!
    end

    it "should return 404 if destination folder could not be found" do
      folder = create(:folder, user: current_user)
      api_post :copy, id: folder.id, parent_id: -1
      assert_not_found!
    end

    it "should fail if folder name already taken in destination folder" do
      source = create(:folder, user: current_user)
      destination = create(:folder, user: current_user)
      existant_in_destination = create(:folder, name: source.name, parent: destination, user: current_user)
      api_post :copy, id: source.id, parent_id: destination.id
      expect(json_response['errors'].keys).to eq(['name'])
      assert_invalid_record!
    end

    it "should copy a folder" do
      source = create(:folder, user: current_user)
      destination = create(:folder, user: current_user)
      expect{
        api_post :copy, id: source.id, parent_id: destination.id
      }.to change{ current_user.folders.count }.by(1)
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(folder_attributes)
    end
  end
end
