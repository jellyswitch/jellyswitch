# typed: strict
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, ActsAsScopable::ModelExtensions)
end
