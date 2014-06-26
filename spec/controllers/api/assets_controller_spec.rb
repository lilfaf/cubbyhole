require 'spec_helper'

describe Api::AssetsController do
  let(:asset_attributes) { [:id, :name, :url, :size, :content_type, :etag, :created_at, :updated_at] }

  describe "indexing files" do
    it "should return 404 error if parent folder not found" do
      api_get :index, parent_id: -1
      assert_not_found!
    end

    it "should get root assets" do
      create(:asset, user: current_user)
      api_get :index, parent_id: 0
      expect(response.status).to eq(200)
      expect(json_response.size).to eq(1)
      expect(json_response.first).to have_attributes(asset_attributes)
    end

    it "should get file inside a folder" do
      container = create(:folder, user: current_user)
      create(:asset, folder: container, user: current_user)
      api_get :index, parent_id: container.id
      expect(response.status).to eq(200)
      expect(json_response.size).to eq(1)
      expect(json_response.first).to have_attributes(asset_attributes)
    end
  end

  describe "showing an asset" do
    it "should return 404 error if asset not found" do
      api_get :show, id: -1
      assert_not_found!
    end

    it "should return folder infos" do
      asset = create(:asset, user: current_user)
      api_get :show, id: asset.id
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(asset_attributes)
    end
  end

  describe "creating an asset" do
    it "should fail with invalid attributes" do
      api_post :create, parent_id: 0, file: build(:asset, size: '', content_type: '', etag: '').attributes
      expect(json_response['errors'].keys).to eq(['size', 'content_type', 'etag'])
      assert_invalid_record!
    end

    it "should return 404 error if parent folder not found" do
      api_post :create, parent_id: -1, file: build(:asset).attributes
      assert_not_found!
    end

    it "should create a new root asset" do
      expect{
        api_post :create, parent_id: 0, file: build(:asset).attributes
      }.to change{ current_user.assets.roots.count }.by(1)
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(asset_attributes)
    end

    it "should create a new asset in parent folder" do
      folder = create(:folder, user: current_user)
      expect{
        api_post :create, parent_id: folder.id, file: build(:asset).attributes
      }.to change{ current_user.assets.count }.by(1)
      expect(response.status).to eq(201)
      expect(json_response).to have_attributes(asset_attributes)
      expect(current_user.assets.last.folder_id).not_to be_nil
    end
  end

  describe "updating an asset" do
    it "should return 404 error if asset not found" do
      api_put :update, id: -1
      assert_not_found!
    end

    it "should fail with invalid attributes" do
      asset = create(:asset, user: current_user)
      api_put :update, id: asset.id, file: { key: '' }
      expect(json_response['errors'].keys).to eq(['key'])
      assert_invalid_record!
    end

    it "should fail if destination folder not found" do
      asset = create(:asset, user: current_user)
      folder = create(:folder, user: current_user)
      api_put :update, id: asset.id, file: { parent_id: -1 }
      assert_not_found!
    end

    it "should change attributes succesfully" do
      asset = create(:asset, user: current_user)
      api_put :update, id: asset.id, file: { name: 'test' }
      expect(response.status).to eq(200)
      expect(json_response).to have_attributes(asset_attributes)
      expect(json_response['name']).to eq('test')
    end

    it "should move the asset" do
      asset = create(:asset, user: current_user)
      folder = create(:folder, user: current_user)
      expect{
        api_put :update, id: asset.id, file: { parent_id: folder.id }
      }.not_to change{ current_user.assets.count }
      expect(response.status).to eq(200)
      expect(folder.assets.last).to eq(asset)
    end

    it "should move the asset to the root" do
      folder = create(:folder, user: current_user)
      asset = create(:asset, user: current_user, folder: folder)
      expect{
        api_put :update, id: asset.id, file: { parent_id: 0 }
      }.not_to change{ current_user.assets.count }.by(1)
      expect(response.status).to eq(200)
      expect(current_user.assets.roots.last).to eq(asset)
    end
  end

  describe "deleting an asset" do
    it "should return 404 error if asset not found" do
      api_delete :destroy, id: -1
      assert_not_found!
    end

    #it "should delete an asset" do
    #  asset = create(:asset)
    #  expect{
    #    api_delete :destroy, id: asset.id
    #  }.to change{ Asset.count }.by(-1)
    #  expect(response.status).to eq(204)
    #end
  end
end
