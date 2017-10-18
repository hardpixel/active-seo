class CreateSeoMeta < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_meta do |t|
      t.string  :title
      t.text    :description
      t.text    :keywords
      t.boolean :noindex
      t.boolean :nofollow
      t.integer :seoable_id,   null: false
      t.string  :seoable_type, null: false

      t.timestamps
    end

    add_index :seo_meta, [:seoable_id, :seoable_type], unique: true
  end
end
