module Scopable
  module Controller
    extend ActiveSupport::Concern

    included do
      controller_attributes.each { |attr| add_has_scope_for_attribute(attr) }
    end

    module ClassMethods
      private

      def controller_attributes
        controller_name.classify.constantize.attribute_names
      end

      def add_has_scope_for_attribute(attr)
        has_scope(attr.to_sym, ->(value) { where(Hash[attr, value]) })
      end
    end
  end

  module Model
    extend ActiveSupport::Concern

    included do
      attribute_names.each { |attr| add_scope_for_attribute(attr) }
    end

    module ClassMethods
      private

      def add_scope_for_attribute(attr)
        scope attr.to_sym, ->(value) { where(Hash[attr, value]) }
      end
    end
  end
end
