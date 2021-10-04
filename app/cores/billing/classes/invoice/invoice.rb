class Billing::Invoice < ApplicationRecord

   self.table_name = :billing_invoices 

   # include extensions
   include Associations, Refactor, Scopes, Validations

end
