class CoreGenerator < Rails::Generators::NamedBase
  
  source_root File.expand_path('templates', __dir__)
  require_relative "../mixins/base_generator_mixin"
  include BaseGeneratorMixin

  def validate_arguments
    validate_name_as_core
  end

  def set_binding
    @core_root = Folder::Application::Cores::Root.join(name)
    @core_name = name.camelcase
  end

  def create_core_directory
    mkdir(@core_root)
  end

  def create_core_subdirectories
    subdirectoties = %w( classes decorators jobs mixin services specs sql )
    subdirectoties.each { |dir| mkdir(@core_root.join(dir)) }
  end

  def create_readme
    template "README.md", @core_root.join("README.md")
  end

  def create_controller_directories
    controller_root = Rails.root.join("app/controllers/#{name.underscore}")
    api_subdir      = controller_root.join('api')
    admin_subdir    = controller_root.join('api/admin')

    mkdir(controller_root)
    mkdir(api_subdir)
    mkdir(admin_subdir)
  end

  def give_instructions
    message = <<~EOL
      
      *** IMPORTANT ***
      The #{@core_name} core has been created succesfully.
      Don't forget to sign the core up for autoloading in /config/application_extensions/cores.rb
      *** IMPORTANT ***

    EOL

    puts message
  end

end
