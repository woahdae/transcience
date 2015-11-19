require 'test_helper'
 
class HamlWithDraperTest < ActionDispatch::IntegrationTest
  test "HAML's auto-id feature works with Draper objects" do
    visit haml_with_draper_path
  end
end
