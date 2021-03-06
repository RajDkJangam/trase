# == Schema Information
#
# Table name: download_attributes
#
#  id           :integer          not null, primary key
#  context_id   :integer          not null
#  position     :integer          not null
#  display_name :text             not null
#  years        :integer          is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  download_attributes_context_id_position_key  (context_id,position) UNIQUE
#  index_download_attributes_on_context_id      (context_id)
#
# Foreign Keys
#
#  fk_rails_...  (context_id => contexts.id) ON DELETE => cascade
#

module Api
  module V3
    class DownloadAttribute < YellowTable
      include Api::V3::StringyArray
      include Api::V3::AssociatedAttributes

      belongs_to :context
      has_one :download_qual, autosave: true
      has_one :download_quant, autosave: true

      validates :context, presence: true
      validates :position, presence: true, uniqueness: {scope: :context}
      validates :display_name, presence: true
      validates_with OneAssociatedAttributeValidator,
                     attributes: [:download_qual, :download_quant]
      validates_with AttributeAssociatedOnceValidator,
                     attribute: :download_qual, if: :new_download_qual_given?
      validates_with AttributeAssociatedOnceValidator,
                     attribute: :download_quant, if: :new_download_quant_given?

      after_commit :refresh_dependencies

      stringy_array :years
      manage_associated_attributes [:download_qual, :download_quant]

      def self.blue_foreign_keys
        [
          {name: :context_id, table_class: Api::V3::Context}
        ]
      end

      def refresh_dependencies
        Api::V3::Readonly::DownloadAttribute.refresh
      end
    end
  end
end
