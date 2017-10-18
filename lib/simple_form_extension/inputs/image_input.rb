module SimpleFormExtension
  module Inputs
    class ImageInput < SimpleForm::Inputs::Base
      include SimpleFormExtension::Translations

      delegate :content_tag, :image_tag, to: :template

      def input(wrapper_options = nil)
        input_html_options[:class] << "image-upload"

        input_markup
      end

      private

      def input_markup
        content_tag(:div, class: 'fileinput fileinput-new', data: { provides: 'fileinput' }) do
          content_tag(:div) do
            content_tag(:div, class: 'btn btn-default btn-file') do
              content_tag(:div, _translate('image.select'), class: 'fileinput-new') +
              content_tag(:div, _translate('image.change'), class: 'fileinput-exists') +
              @builder.file_field(attribute_name, input_html_options)
            end +

            content_tag(:button, class: 'btn btn-danger fileinput-exists', type: 'button', data: { dismiss: 'fileinput' }) do
              content_tag(:i, '', class: 'fa fa-times')
            end
          end +

          content_tag(:div, class: 'fileinput-preview thumbnail') do
            existing_image_tag
          end
        end
      end

      def existing_image_tag
        if @builder.object.send(:"#{ attribute_name }?")
          image_url = @builder.object.send(attribute_name).url(image_style)

          container_style = 'position: relative; height: 100%; width: 100%; min-height: 50px;min-width: 58px; display: block;'

          content_tag(:div, style: container_style, data: { provides: 'existing-file' }) do
            image_tag(image_url, style: 'height: 100%; width: 100%; display: block;', data: { toggle: 'existing-file' }) +
            remove_image_button
          end
        else
          content_tag(:div, '', class: 'empty-thumbnail')
        end
      end

      def remove_image_button
        return unless object.respond_to?(:"#{ remove_attachment_method }=")

        button_style = 'position: absolute; top: 10px; left: 10px;'

        content_tag(:button, class: 'btn btn-danger', style: button_style, type: 'button', data: { dismiss: 'existing-file' }) do
          content_tag(:i, '', class: 'fa fa-remove', data: { :'removed-class' => 'fa fa-refresh' }) +
          @builder.hidden_field(remove_attachment_method, class: 'remove-file-input', value: nil)
        end
      end

      def remove_attachment_method
        options[:remove_method] || :"remove_#{ attribute_name }"
      end

      def image_style
        styles = @builder.object.send(attribute_name).styles.map(&:first)
        # Check if there's a :thumb or :thumbnail style in attachment definition
        thumb = styles.find { |s| %w(thumb thumbnail).include?(s.to_s) }
        # Return the potentially smallest size !
        thumb || styles.first || :original
      end
    end
  end
end
