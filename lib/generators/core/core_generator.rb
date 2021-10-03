class CoreGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

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
