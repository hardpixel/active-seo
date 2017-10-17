class CreateSeoMeta < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_meta do |t|
      t.string  :title
      t.text    :description
      t.text    :keywords
      t.integer :seoable_id
      t.string  :seoable_type

      t.timestamps
    end

    add_index :seo_meta, [:seoable_id, :seoable_type], unique: true
  end
end
