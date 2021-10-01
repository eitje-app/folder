class Folder::Application < Rails::Application

  module Cores
    Namespace = %i( billing )
    TopLevel  = %i( firm )
    All       = Namespace | TopLevel
  end

  namespace_core_collapses = [
    Rails.application.root.join("app/cores/#{Cores::Namespace.join(',')}/{classes,jobs,decorators,sql}"),
    Rails.application.root.join("app/cores/#{Cores::Namespace.join(',')}/classes/*"),
    Rails.application.root.join("app/cores/#{Cores::Namespace.join(',')}/classes/**/extensions"),
  ]

  top_level_core_collapses = [
    Rails.application.root.join("app/cores/#{Cores::TopLevel.join(',')}"),
    Rails.application.root.join("app/cores/#{Cores::TopLevel.join(',')}/{classes,jobs,decorators,sql}"),
    Rails.application.root.join("app/cores/#{Cores::TopLevel.join(',')}/classes/*"),
    Rails.application.root.join("app/cores/#{Cores::TopLevel.join(',')}/classes/**/extensions"),
  ]

  controller_collapses = [
    Rails.application.root.join("app/controllers/*/"),
  ]

  all_collapses = namespace_core_collapses | top_level_core_collapses | controller_collapses

  Rails.autoloaders.main.collapse(all_collapses)

end