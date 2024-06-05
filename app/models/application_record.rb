class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def as_serialized_json(serializer_name: self.class.name, serializer_options: {})
    "#{serializer_name}Serializer".safe_constantize.new(self, serializer_options).serializable_hash[:data][:attributes]
  end
end
