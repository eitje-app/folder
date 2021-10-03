class CoreClassExtGenerator < Rails::Generators::NamedBase
  
  source_root File.expand_path('templates', __dir__)
  require_relative "../mixins/base_generator_mixin"
  include BaseGeneratorMixin
  require_relative "../mixins/core_class_generator_mixin"
  include CoreClassGeneratorMixin

  argument :extensions, type: :array, default: []
  class_option :"create-defaults", type: :boolean, default: false

  def validate_arguments   
    validate_name_as_core_class
    unless extensions.present? || options["create-defaults"]
      raise ArgumentError, "no extensions were given, pass as: `rails generate core_class_ext core_name/class_name ext_name_one ext_name_two`"
    end
  end

  def set_binding
    set_core_class_based_binding
  end

  def create_extensions
   all_extensions.each do |ext|
      @extension_const = "#{@class_const}::#{ext.camelcase}"
      template "extension.rb.tt", "#{@extensions_dir}/#{ext}.rb"
    end
  end

  private

  def all_extensions
    extensions | defaults
  end

  def defaults
    options["create-defaults"] ? Folder::Application::Extensions::Default : []
  end

end
