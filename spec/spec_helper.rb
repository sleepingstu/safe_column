$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'safe_column'

require 'my_amazing_model'
require 'normal_model'

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
    table.column :published, :boolean, :default => false
    table.timestamps
  end

  create_table :normal_models do |table|
    table.column :field, :string
  end
end

class Minitest::Spec
  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end