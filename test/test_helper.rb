$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'safe_column'

require 'my_amazing_model'
require 'minitest/autorun'
require 'database_cleaner'
require 'pry'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :my_amazing_models do |table|
    table.column :title, :string
    table.column :body, :text
  end
end

class Minitest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end