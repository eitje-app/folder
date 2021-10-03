class CoreClassGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  include Rails::Generators::Migration
  class_option :"skip-migration", type: :boolean, default: false

  def validate_arguments
    unless name =~ /^[a-z|_]{1,}\/[a-z|_]{1,}$/
      raise ArgumentError, "the argument should be of the format 'core_name/class_name'"
    end
  end

  def set_binding
    @core_name   = name.split('/').first.camelcase
    @class_name  = name.split('/').last.camelcase
    @namespace   = !options['skip_namespace']
    @class_const = @namespace ? "#{@core_name}::#{@class_name}" : @class_name
    @table_name  = @class_const.gsub('::','_').underscore.pluralize
    @core_root   = Folder::Application::Cores::Root.join(@core_name.underscore)
  end

  def create_classes_contents
    @classes_dir    = @core_root.join("classes/#{@class_name.underscore}")
    @extensions_dir = @classes_dir.join("extensions")

    Dir.mkdir(@classes_dir)
    Dir.mkdir(@extensions_dir)
    template "class.rb.tt", @classes_dir.join("#{@class_name.underscore}.rb")
  end

  def create_decorators_contents
    @decorator_dir   = @core_root.join('decorators')
    @decorator_name  = "#{@class_name}Decorator"
    @decorator_const = "#{@class_const}Decorator"

    template "decorator.rb.tt", @decorator_dir.join("#{@decorator_name.underscore}.rb")
  end

  def create_specs_contents
    @spec_dir = @core_root.join('specs')
    
    template "spec.rb.tt", @spec_dir.join("#{@class_name.underscore}_spec.rb")
  end

  def create_migration_file
    return if options["skip-migration"]

    @migration_const     = "Create#{@table_name.camelcase}"
    @migration_dir       = Rails.root.join("db/migrate")
    @migration_version   = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
    @migration_timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")

    template "migration.rb", @migration_dir.join("#{@migration_timestamp}_create_#{@table_name}.rb")
  end

end
