# typed: false
module ActsAsScopable
  def self.current_scope_resources=(resources)
    RequestStore.store[:scope_resources] = resources
  end

  def self.current_scope_resources
    RequestStore.store[:scope_resources] || []
  end

  module ModelExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_scopable(*resources)
        default_scope lambda {
          if ActsAsScopable.current_scope_resources.present?
            query_criteria = ActsAsScopable.current_scope_resources.each_with_object({}) do |record, criteria|
              criteria["#{record.class.name.downcase}_id".to_sym] = record.id
            end

            where(query_criteria)
          else
            all
          end
        }
      end
    end
  end
end
