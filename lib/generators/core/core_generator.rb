class CoreGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def set_binding
    @core_root = Folder::Application::Cores::Root.join(name)
    @core_name = name.camelcase
  end

  def create_core_directory
    Dir.mkdir(@core_root)
  end

  def create_core_subdirectories
    subdirectoties = %w( classes decorators jobs mixin specs sql )
    subdirectoties.each { |dir| Dir.mkdir(@core_root.join(dir)) }
  end

  def create_readme
    template "README.md", @core_root.join("README.md")
  end

end
