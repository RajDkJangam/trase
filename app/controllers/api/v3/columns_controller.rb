module Api
  module V3
    class ColumnsController < ApiController
      def index
        @node_types = Api::V3::NodeType.
          joins(context_node_types: :context_node_type_property).
          joins("LEFT JOIN #{Api::V3::Profile.table_name} ON profiles.context_node_type_id = context_node_types.id").
          select('node_types.id, context_node_types.column_position as position, context_node_type_properties.column_group as group, node_types.name as name, context_node_type_properties.is_default, context_node_type_properties.is_geo_column as is_geo, profiles.name as profile_type').
          where('context_node_types.context_id = :context_id', context_id: @context.id).
          order('context_node_types.column_position ASC')

        render json: @node_types, root: 'data', each_serializer: Api::V3::Columns::ColumnSerializer
      end
    end
  end
end
