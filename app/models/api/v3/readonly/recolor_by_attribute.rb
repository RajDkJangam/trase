module Api
  module V3
    module Readonly
      class RecolorByAttribute < BaseModel
        self.table_name = 'revamp.recolor_by_attributes_mv'
        belongs_to :context
        belongs_to :readonly_attribute, foreign_key: :attribute_id, class_name: 'Attribute'

        delegate :name, to: :readonly_attribute
        delegate :display_name, to: :readonly_attribute
        delegate :original_type, to: :readonly_attribute
        delegate :original_id, to: :readonly_attribute
      end
    end
  end
end