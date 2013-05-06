require 'spec_helper'

describe "images/index" do
  before(:each) do
    assign(:images, [
      stub_model(Image,
        :url => "Url",
        :name => "Name",
        :view => "View",
        :vehicle => nil
      ),
      stub_model(Image,
        :url => "Url",
        :name => "Name",
        :view => "View",
        :vehicle => nil
      )
    ])
  end

  it "renders a list of images" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "View".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
