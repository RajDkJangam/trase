# == Schema Information
#
# Table name: download_versions
#
#  id         :integer          not null, primary key
#  context_id :integer          not null
#  symbol     :string           not null
#  is_current :boolean          default(FALSE), not null
#  created_at :datetime         not null
#
# Indexes
#
#  download_versions_context_id_symbol_key               (context_id,symbol) UNIQUE
#  index_download_versions_on_context_id_and_is_current  (context_id,is_current) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (context_id => contexts.id) ON DELETE => cascade
#

module Api
  module V3
    class DownloadVersion < BlueTable
      def self.current_version_symbol(context)
        current_version = where(is_current: true, context_id: context.id).
          order('created_at DESC').
          first
        current_version&.symbol
      end

      def self.import_key
        [
          {name: :context_id, sql_type: 'INT'},
          {name: :symbol, sql_type: 'TEXT'}
        ]
      end

      def self.blue_foreign_keys
        [
          {name: :context_id, table_class: Api::V3::Context}
        ]
      end
    end
  end
end
