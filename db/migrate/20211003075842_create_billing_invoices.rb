class CreateBillingInvoices < ActiveRecord::Migration[6.1]

  def change
  create_table :billing_invoices do |t|
    t.timestamps
    t.string :amt
    end
  end
  
end
