require 'spec_helper'

class SafeColumnSpec < Minitest::Spec
  describe "A Model with SafeColumn included" do
    let(:model) { MyAmazingModel.create!(:title => "<h3>This is a title</h3>",
        :body => "<p>This is a body</p>") }

    describe "without safe_columns" do
      it "returns the underlying string" do
        model.title.class.must_equal String
        model.body.class.must_equal String
      end
    end

    describe "when safe columns are specified" do
      it "wraps it in an ActiveSupport::SafeBuffer" do
        model.safe_columns = %i(title body)
        model.reload

        model.title.class.must_equal ActiveSupport::SafeBuffer
        model.body.class.must_equal ActiveSupport::SafeBuffer
      end
    end
  end

  describe "Any other model" do
    let(:model) { NormalModel.create!(:field => "Field") }

    it "works fine without it" do
      model.field.must_equal "Field"
    end
  end
end