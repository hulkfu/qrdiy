class CreateIdea < ActiveRecord::Migration[5.0]
  def change
    create_table :ideas do |t|
      t.text :content
    end
  end
end
