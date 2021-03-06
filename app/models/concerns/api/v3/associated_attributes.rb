require 'active_support/concern'
module Api
  module V3
    module AssociatedAttributes
      extend ActiveSupport::Concern

      class_methods do
        def manage_associated_attributes(ary)
          @associated_attributes = ary

          @associated_attributes.each do |attr_name|
            define_method(:"new_#{attr_name}_given?") do
              send(attr_name).present? && !send(attr_name).marked_for_destruction?
            end
          end
        end

        def associated_attributes
          @associated_attributes
        end
      end

      def readonly_attribute_id
        readonly_attribute&.id
      end

      def readonly_attribute_display_name
        readonly_attribute&.display_name
      end

      def readonly_attribute_name
        readonly_attribute&.name
      end

      def readonly_attribute_id=(id)
        self.readonly_attribute = Api::V3::Readonly::Attribute.find_by_id(id)
      end

      private

      def associated_attributes
        self.class.instance_variable_get(:@associated_attributes)
      end

      def readonly_attribute
        @readonly_attribute || (@readonly_attribute = find_readonly_attribute)
      end

      # iterates over declared associated attributes
      # returns the first actual associated attribute found
      def find_readonly_attribute
        assoc_attr_names_with_types.detect do |attr_name, attr_type|
          # no good way to preload this
          readonly_attribute = Api::V3::Readonly::Attribute.where(
            original_id: send(attr_name)&.send(:"#{attr_type}_id"),
            original_type: attr_type.capitalize
          ).first
          break readonly_attribute if readonly_attribute.present?
          false
        end
      end

      def readonly_attribute=(readonly_attribute)
        return unless readonly_attribute

        assoc_attr_names_with_types.each do |attr_name, attr_type|
          assign_associated_object(readonly_attribute, attr_name, attr_type)
        end
      end

      def assign_associated_object(readonly_attribute, attr_name, attr_type)
        assoc_obj = send(attr_name)
        if readonly_attribute.original_type != attr_type.capitalize
          # delete when saving parent
          send(attr_name)&.mark_for_destruction
        elsif assoc_obj
          # update existing associated object with new attribute id
          assoc_obj.send(:"#{attr_type}_id=", readonly_attribute.original_id)
        else
          # build a new associated object (saved with parent)
          send(:"build_#{attr_name}", :"#{attr_type}_id" => readonly_attribute.original_id)
        end
      end

      def assoc_attr_names_with_types
        associated_attributes.map do |attr_name|
          attr_type = attr_name.to_s.split('_').last
          raise "Cannot infer type from #{attr_name}" unless attr_type
          [attr_name, attr_type]
        end
      end
    end
  end
end
