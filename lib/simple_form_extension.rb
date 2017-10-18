require 'simple_form_extension/version'
require 'redactor-rails'
require 'selectize-rails'
require 'simple_form'

module SimpleFormExtension
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Translations
    autoload :ResourceNameHelper
    autoload :Components
    autoload :Inputs
  end

  # Allows overriding which methods are used by the fields that try to fetch
  # the name of a resource to display it instead of calling #to_s
  #
  mattr_accessor :resource_name_methods
  @@resource_name_methods = [:name, :title]
end

SimpleForm::Inputs::Base.send(:include, SimpleFormExtension::Components::Icons)
SimpleForm::Inputs::Base.send(:include, SimpleFormExtension::Components::Popovers)

SimpleForm.custom_inputs_namespaces << 'SimpleFormExtension::Inputs'

require 'simple_form_extension/railtie' if defined?(Rails)
