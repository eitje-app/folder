class CoreClassGenerator < Rails::Generators::NamedBase
  
  source_root File.expand_path('templates', __dir__)
  require_relative "../mixins/base_generator_mixin"
  include BaseGeneratorMixin
  require_relative "../mixins/core_class_generator_mixin"
  include CoreClassGeneratorMixin
  include Rails::Generators::Migration
  
  class_option :"skip-decorator",  type: :boolean, default: false
  class_option :"skip-controller", type: :boolean, default: false
  class_option :"skip-spec",       type: :boolean, default: false
  class_option :"skip-migration",  type: :boolean, default: false

  def validate_arguments
    validate_name_as_core_class
  end

  def set_binding
    set_core_class_based_binding
  end

  def create_classes_contents
    mkdir(@classes_dir)
    mkdir(@extensions_namespace_dir)
    mkdir(@extensions_dir)
    template "class.rb.tt", @classes_dir.join("#{@class_name.underscore}.rb")
  end

  def create_controller_contents
    return if options["skip-controller"]
    file_name = "#{@controller_name.underscore}.rb"
    template "api_controller.rb.tt", @controller_root.join("api/#{file_name}")
    template "admin_controller.rb.tt", @controller_root.join("api/admin/#{file_name}")
  end

  def create_decorators_contents
    return if options["skip-decorator"]
    template "decorator.rb.tt", @decorator_dir.join("#{@decorator_name.underscore}.rb")
  end

  def create_specs_contents
    return if options["skip-spec"]  
    template "spec.rb.tt", @spec_dir.join("#{@class_name.underscore}_spec.rb")
  end

  def create_migration_file
    return if options["skip-migration"]
    template "migration.rb", @migration_dir.join("#{@migration_timestamp}_create_#{@table_name}.rb")
  end

end
