module Scopable
  module Controller
    extend ActiveSupport::Concern

    # Add has_scope for each model attribute
    included do
      controller_name.classify.constantize.attribute_names.each do |a|
        has_scope a.to_sym, ->(value) { where(Hash[a, value]) }, only: :index
      end
    end
  end

  module Model
    extend ActiveSupport::Concern

    # Add scope for each model attribute
    included do
      self.attribute_names.each do |a|
        scope a.to_sym, ->(value) { where(Hash[a, value]) }
      end
    end
  end
end
