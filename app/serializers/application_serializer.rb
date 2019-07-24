class ApplicationSerializer < ActiveModel::Serializer
  def self.all_fields
    @model.header_mapping.values
  end
end
