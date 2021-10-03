
require_relative "boot"
require_relative "application_extensions/railties"

Bundler.require(*Rails.groups)

module Folder
  class Application < Rails::Application

    config.load_defaults 6.1
    config.api_only = true

  end
end

require_relative "application_extensions/database_connection"
require_relative "application_extensions/cores"