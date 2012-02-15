module Gateway
  module Feature
    module CategorizeError
      def self.included(klass)
        klass.class_eval do
          class_attribute :error_catalog, :error_categories
          self.error_catalog = {}
          self.error_categories = [:bad_gateway, :timeout, :retry]

          extend ClassMethods
        end
      end

      protected

      def errors_for(action, error_category)
        action = action.to_s
        cat = self.error_catalog[error_category]
        return [] if cat.blank?

        errors  = cat[action] ? cat[action][:errors] : []
        default_errors = cat['all'][:errors] || []
        errors + default_errors
      end

      def error_callbacks_for(action, error_category)
        action = action.to_s
        cat = self.error_catalog[error_category]
        return [] if cat.blank?

        lambdas = cat[action]  ? cat[action][:lambdas] : []
        default_lambdas = cat['all'][:lambdas] || []
        lambdas + default_lambdas
      end

      def run_callbacks_for(action, error_category)
        action = action.to_s
        error_callbacks_for(action, error_category).each do |cb|
          cb.call self
        end
      end

      module ClassMethods
        protected

        def categorize_error(*params, &block)
          errors, actions, categories = extract_params(params)

          self.error_catalog ||= {}

          categories.each do |error_category|
            self.error_catalog[error_category] ||= {}
            actions.each do |action|
              self.error_catalog[error_category][action] ||= {}
              self.error_catalog[error_category][action][:errors] ||= []
              self.error_catalog[error_category][action][:errors] += errors
              self.error_catalog[error_category][action][:lambdas] ||= []
              self.error_catalog[error_category][action][:lambdas] << block if block
            end
          end
        end

        def extract_params(params)
          opt = params.pop
          opt ||= {}
          errors = params.flatten

          actions = [opt[:for]].flatten.compact
          actions = ['all'] if actions.blank?

          # convert actions to string
          actions.map!{ |action| action.to_s }

          categories = [opt[:as]].flatten.compact
          categories = error_categories if categories.blank?

          categories.each do |error_category|
            unless error_categories.include?(error_category.to_sym)
              raise "Error Category: #{error_category} must be one of #{error_categories}."
            end
          end

          [errors, actions, categories]
        end
      end
    end
  end
end
