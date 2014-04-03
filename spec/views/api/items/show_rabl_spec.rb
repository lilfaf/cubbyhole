require 'spec_helper'

describe 'item show rabl tmpl' do

  let(:folder) { create(:folder) }
  let(:valid_json) {
    {
      id: folder.id,
      name: folder.name,
      type: 'folder'
    }.to_json
  }

  let(:render) {
    Rabl.render(folder, 'items/show', view_path: 'app/views/api')
  }

  it 'should render valid_json' do
    expect(render).to eq(valid_json)
  end
end
