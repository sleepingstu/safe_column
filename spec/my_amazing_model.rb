class MyAmazingModel < ActiveRecord::Base

  include SafeColumn

  allow_safe_columns %i(title body)

end