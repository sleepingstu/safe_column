class MyAmazingModel < ActiveRecord::Base

  include SafeColumn

  allow_safe_columns %i(title body)

end

class MyAmazingSubClassModel < MyAmazingModel
end

class ThirdLevelSubClass < MyAmazingSubClassModel
end