class CreatePrints < ActiveRecord::Migration[5.0]
  def change
    create_table :prints do |t|
      t.belongs_to :code, index: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
