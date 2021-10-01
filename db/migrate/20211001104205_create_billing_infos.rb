class CreateBillingInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_infos do |t|
      t.timestamps
      t.string "company_name"
      t.string "person_name"
    end
  end
end
