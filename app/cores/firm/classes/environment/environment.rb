class Environment # < ApplicationRecord

  # self.table_name = :billing_infos

  include Text

  include Mixin::Firmable

  def self.test
    puts "success"
  end

end