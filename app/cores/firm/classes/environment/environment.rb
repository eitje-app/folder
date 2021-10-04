class Environment < ApplicationRecord

  include Associations, Refactor, Scopes, Validations, Text

  include Mixin::Firmable

  def self.test
    puts "success"
  end

end