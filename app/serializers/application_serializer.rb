class ApplicationSerializer < ActiveModel::Serializer
  def self.all_fields
    @model.new.attributes.keys
  end
end
