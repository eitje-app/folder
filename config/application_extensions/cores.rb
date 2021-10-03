class Folder::Application < Rails::Application

  module Cores
    Namespace = %i( billing planning )
    TopLevel  = %i( firm revenue )
    All       = Namespace | TopLevel
    Root      = Rails.root.join('app/cores')
  end

  ###############################
  # configure Zeitwerk collapses
  ###############################

  namespace_core_collapses = [
    Rails.application.root.join("app/cores/{#{Cores::Namespace.join(',')}}/{classes,jobs,decorators,sql,services}"),
    Rails.application.root.join("app/cores/{#{Cores::Namespace.join(',')}}/classes/*"),
    Rails.application.root.join("app/cores/{#{Cores::Namespace.join(',')}}/classes/**/extensions"),
  ]

  top_level_core_collapses = [
    Rails.application.root.join("app/cores/{#{Cores::TopLevel.join(',')}}"),
    Rails.application.root.join("app/cores/{#{Cores::TopLevel.join(',')}}/{classes,jobs,decorators,sql,services}"),
    Rails.application.root.join("app/cores/{#{Cores::TopLevel.join(',')}}/classes/*"),
    Rails.application.root.join("app/cores/{#{Cores::TopLevel.join(',')}}/classes/**/extensions"),
  ]

  controller_collapses = [
    Rails.application.root.join("app/controllers/*/"),
  ]

  all_collapses = namespace_core_collapses | top_level_core_collapses | controller_collapses

  Rails.autoloaders.main.collapse(all_collapses)

  ###############################
  # configure Zeitwerk ignores
  ###############################

  namespace_core_ignores = [
    Rails.application.root.join("app/cores/{#{Cores::Namespace.join(',')}}/{specs}")
  ]

  top_level_core_ignores = [
    Rails.application.root.join("app/cores/{#{Cores::TopLevel.join(',')}}/{specs}")
  ]

  all_ignores = namespace_core_ignores | top_level_core_ignores

  Rails.autoloaders.main.ignore(all_ignores)

end