# -*- coding: utf-8 -*-

ActiveRecord::Schema.define(:version => 0) do
  create_table "struct_members", :force => true do |t|
    t.integer :struct_id,                 :default => 0,  :null => false
    t.string  :struct_type, :limit => 50, :default => "", :null => false
    t.string  :name,        :limit => 50, :default => "", :null => false
    t.string  :value_type,  :limit => 50, :default => "", :null => false
    t.binary  :value
  end

  add_index("struct_members", ["struct_id", "struct_type", "name"],
            :name=>"struct_memebers_id_type_name_index")

  create_table :people, :force => true do |t|
    t.string  :name
    t.integer :age
  end
  create_table :places, :force => true do |t|
    t.string  :name
    t.boolean :network
    t.string  :region
  end
  create_table :posts, :force => true do |t|
    t.string :type
    t.string :title
    t.string :name
    t.text :body
  end
  create_table :comments, :force => true do |t|
    t.string :name
    t.text :body
  end
end

