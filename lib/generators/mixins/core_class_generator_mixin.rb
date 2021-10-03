module CoreClassGeneratorMixin
  extend ActiveSupport::Concern
  included do

    def set_core_class_based_binding   
      @namespace                = !options['skip_namespace']
      
      @core_name                = name.split('/').first.camelcase
      @core_root                = Folder::Application::Cores::Root.join(@core_name.underscore)

      @class_name               = name.split('/').last.camelcase
      @class_const              = @namespace ? "#{@core_name}::#{@class_name}" : @class_name

      @decorator_dir            = @core_root.join('decorators')
      @decorator_name           = "#{@class_name}Decorator"
      @decorator_const          = "#{@class_const}Decorator"

      @table_name               = @class_const.gsub('::','_').underscore.pluralize
   
      @controller_root          = Rails.root.join("app/controllers/#{@core_name.underscore}")
      @controller_name          = "#{@table_name.camelcase}Controller"
   
      @classes_dir              = @core_root.join("classes/#{@class_name.underscore}")
      @extensions_namespace_dir = @classes_dir.join(@class_name.underscore)
      @extensions_dir           = @extensions_namespace_dir.join("extensions")

      @spec_dir                 = @core_root.join('specs')
   
      @migration_const          = "Create#{@table_name.camelcase}"
      @migration_dir            = Rails.root.join("db/migrate")
      @migration_version        = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
      @migration_timestamp      = Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

  end
end