require 'test_helper'

class SafeColumnTest < Minitest::Test
  def setup
    @model = MyAmazingModel.create!(:title => "<h3>This is a title</h3>",
      :body => "<p>This is a body</p>")
  end

  def test_columns_are_not_html_safe_by_default
    assert_equal String, @model.title.class
    assert_equal String, @model.body.class
  end

  def test_columns_are_made_html_safe_when_whitelisted
    @model.safe_columns = %i(title body)
    @model.reload

    assert_equal ActiveSupport::SafeBuffer, @model.title.class
    assert_equal ActiveSupport::SafeBuffer, @model.body.class
  end
end
