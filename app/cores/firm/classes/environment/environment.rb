=begin

== Schema information for table 'environments'

column_name     column_type     column_default     

created_at      datetime        -                  
id              integer         -                  
location        string          -                  
name            string          -                  
updated_at      datetime        -                  

=end

class Environment < ApplicationRecord

  include Text

  include Mixin::Firmable

  def self.test
    puts "success"
  end

end