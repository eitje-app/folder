class Billing::Info < ApplicationRecord

  self.table_name = :billing_infos

  # include extensions, to do: create helper to include all at once, e.g. include_extensions

  include Associations, Refactor, Scopes, Validations, Text

  # mixin -> remains to be dependent on namespace
  include Billing::Mixin::Billable

  def self.test
    puts "success"
  end

end