=begin

== Schema information for table 'billing_invoices'

column_name     column_type     column_default     

amt             string          -                  
created_at      datetime        -                  
id              integer         -                  
updated_at      datetime        -                  

=end

class Billing::Invoice < ApplicationRecord

   self.table_name = :billing_invoices 

end
