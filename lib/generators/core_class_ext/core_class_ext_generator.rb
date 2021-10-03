class CoreClassExtGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  argument :extensions, type: :array, default: []

  def validate_arguments
    
    unless name =~ /^[a-z|_]{1,}\/[a-z|_]{1,}$/
      raise ArgumentError, "the argument should be of the format 'core_name/class_name'"
    end
    
    unless extensions.present?
      raise ArgumentError, "no extensions were given, pass as: `rails generate core_class_ext core_name/class_name ext_name_one ext_name_two`"
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

    @classes_dir    = @core_root.join("classes/#{@class_name.underscore}")
    @extensions_dir = @classes_dir.join("#{@class_name.underscore}/extensions")
  end

  def create_extensions
   extensions.each do |ext|
      @extension_const = "#{@class_const}::#{ext.camelcase}"
      template "extension.rb.tt", "#{@extensions_dir}/#{ext}.rb"
    end
  end

end
