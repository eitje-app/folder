=begin

== Schema information for table 'billing_infos'

column_name      column_type     column_default     

company_name     string          -                  
created_at       datetime        -                  
id               integer         -                  
person_name      string          -                  
updated_at       datetime        -                  

=end

class Billing::Info < ApplicationRecord

  self.table_name = :billing_infos

  # extension -> create helper to include all at once, e.g. include_extensions
  include Text

  # mixin -> remains to be dependant on namespace
  include Billing::Mixin::Billable

  def self.test
    puts "success"
  end

end