# == Schema Information
#
# Table name: context_node_types
#
#  id              :integer          not null, primary key
#  context_id      :integer          not null
#  node_type_id    :integer          not null
#  column_position :integer          not null
#  created_at      :datetime         not null
#
# Indexes
#
#  context_node_types_context_id_node_type_id_key  (context_id,node_type_id) UNIQUE
#  index_context_node_types_on_context_id          (context_id)
#  index_context_node_types_on_node_type_id        (node_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (context_id => contexts.id) ON DELETE => cascade
#  fk_rails_...  (node_type_id => node_types.id) ON DELETE => cascade
#

module Api
  module V3
    class ContextNodeType < BlueTable
      belongs_to :node_type
      belongs_to :context
      has_one :context_node_type_property
      has_one :profile

      validates :context, presence: true
      validates :node_type, presence: true, uniqueness: {scope: :context}
      validates :column_position, presence: true

      def self.select_options
        Api::V3::ContextNodeType.includes(
          context: [:country, :commodity]
        ).all.map do |ctx_nt|
          [
            [
              ctx_nt.context&.country&.name,
              ctx_nt.context&.commodity&.name,
              ctx_nt.node_type&.name
            ].join(' / '),
            ctx_nt.id
          ]
        end
      end

      def self.import_key
        [
          {name: :context_id, sql_type: 'INT'},
          {name: :node_type_id, sql_type: 'INT'}
        ]
      end

      def self.blue_foreign_keys
        [
          {name: :context_id, table_class: Api::V3::Context},
          {name: :node_type_id, table_class: Api::V3::NodeType}
        ]
      end
    end
  end
end
