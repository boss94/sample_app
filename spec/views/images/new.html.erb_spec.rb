require 'spec_helper'

describe "images/new" do
  before(:each) do
    assign(:image, stub_model(Image,
      :url => "MyString",
      :name => "MyString",
      :view => "MyString",
      :vehicle => nil
    ).as_new_record)
  end

  it "renders new image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", images_path, "post" do
      assert_select "input#image_url[name=?]", "image[url]"
      assert_select "input#image_name[name=?]", "image[name]"
      assert_select "input#image_view[name=?]", "image[view]"
      assert_select "input#image_vehicle[name=?]", "image[vehicle]"
    end
  end
end
