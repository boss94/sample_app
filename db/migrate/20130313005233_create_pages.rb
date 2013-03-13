class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :content_typetext
      t.text :content_fulltext

      t.timestamps
    end
  end
end
