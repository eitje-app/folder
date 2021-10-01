class Environment < ApplicationRecord

  include Text

  include Mixin::Firmable

  def self.test
    puts "success"
  end

end