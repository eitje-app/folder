class CreateEnvironments < ActiveRecord::Migration[6.1]
  def change
    create_table :environments do |t|
      t.timestamps
      t.string :name
      t.string :location
    end
  end
end
