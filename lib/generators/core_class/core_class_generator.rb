class CoreClassGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  include Rails::Generators::Migration
  
  class_option :"skip-decorator",  type: :boolean, default: false
  class_option :"skip-controller", type: :boolean, default: false
  class_option :"skip-spec",       type: :boolean, default: false
  class_option :"skip-migration",  type: :boolean, default: false

  def validate_arguments
    unless name =~ /^[a-z|_]{1,}\/[a-z|_]{1,}$/
      raise ArgumentError, "the argument should be of the format 'core_name/class_name'"
    end
  end

  def set_binding
    # make mixin
    @core_name   = name.split('/').first.camelcase
    @class_name  = name.split('/').last.camelcase
    @namespace   = !options['skip_namespace']
    @class_const = @namespace ? "#{@core_name}::#{@class_name}" : @class_name
    @table_name  = @class_const.gsub('::','_').underscore.pluralize
    @core_root   = Folder::Application::Cores::Root.join(@core_name.underscore)
  end

  def create_classes_contents
    @classes_dir              = @core_root.join("classes/#{@class_name.underscore}")
    @extensions_namespace_dir = @classes_dir.join(@class_name.underscore)
    @extensions_dir           = @extensions_namespace_dir.join("extensions")

    mkdir(@classes_dir)
    mkdir(@extensions_namespace_dir)
    mkdir(@extensions_dir)
    template "class.rb.tt", @classes_dir.join("#{@class_name.underscore}.rb")
  end

  def create_controller_contents
    return if options["skip-controller"]

    @controller_root = Rails.root.join("app/controllers/#{@core_name.underscore}")
    @controller_name = "#{@table_name.camelcase}Controller"
    file_name        = "#{@controller_name.underscore}.rb"

    template "api_controller.rb.tt", @controller_root.join("api/#{file_name}")
    template "admin_controller.rb.tt", @controller_root.join("api/admin/#{file_name}")
  end

  def create_decorators_contents
    return if options["skip-decorator"]
    
    @decorator_dir   = @core_root.join('decorators')
    @decorator_name  = "#{@class_name}Decorator"
    @decorator_const = "#{@class_const}Decorator"

    template "decorator.rb.tt", @decorator_dir.join("#{@decorator_name.underscore}.rb")
  end

  def create_specs_contents
    return if options["skip-spec"]
    
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

  private

  def mkdir(directory)
    Dir.mkdir(directory)
    print_mkdir(directory)
  end

  def print_mkdir(directory)
    subdir = directory.to_s.slice /\/app\/[a-zA-Z_\/]{1,}/
    puts "created directory #{subdir}"
  end
end
