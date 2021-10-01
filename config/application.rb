
=begin

to do
  – git 
  – models arch
  – controllers los
  – ORM config
  – routers / R&R config
  – base classes where? e.g. ApplicationRecord
  - namespaceless core
  – delete other directories, still play ball?

side / minor
  – application.rb split
  – routes split

=end

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module Folder
  class Application < Rails::Application

    config.load_defaults 6.1
    config.api_only = true

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

    Rails.autoloaders.main.collapse( namespace_core_collapses | top_level_core_collapses | controller_collapses )

    # somehow pass to RSpec
    # specs = Dir[Rails.application.root.join("app/cores/**/classes*")]

    # controllers       = Dir[Rails.application.root.join("app/cores/**/controllers/*/*")]
    # controllers_api   = controllers.grep /\/api\//
    # controllers_admin = controllers.grep /\/admin\//
    # autoload "Api::BillingInfosController", controllers_api.first

  end
end
