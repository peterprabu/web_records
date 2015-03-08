require 'rails_helper'

RSpec.describe "websites/index.html.erb", type: :view do
  it "has a label called Search for" do
    render
    response.should render_template(:index)
    response.should have_content('Search for')
    expect(response).to have_field('Search for')
  end
end
