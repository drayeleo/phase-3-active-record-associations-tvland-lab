class AddCatchphraseToCharacters < ActiveRecord::Migration[6.1]
  def change
    # Your code here
    change_table :characters do |t|
      t.string :catchphrase
    end
  end
end
