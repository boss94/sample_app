require 'spec_helper'

describe "images/edit" do
  before(:each) do
    @image = assign(:image, stub_model(Image,
      :url => "MyString",
      :name => "MyString",
      :view => "MyString",
      :vehicle => nil
    ))
  end

  it "renders the edit image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", image_path(@image), "post" do
      assert_select "input#image_url[name=?]", "image[url]"
      assert_select "input#image_name[name=?]", "image[name]"
      assert_select "input#image_view[name=?]", "image[view]"
      assert_select "input#image_vehicle[name=?]", "image[vehicle]"
    end
  end
end
