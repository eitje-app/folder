class Folder::Application < Rails::Application

=begin

  This configuration makes the application connect to our database
  while booting, thereby providing model introspection on startup.

  Immediately see:

    Environment(id: integer, created_at: datetime)

  Instead of:

    Environment (call 'Environment.connection' to establish a connection)

=end

  console do
    ActiveRecord::Base.connection
  end

end