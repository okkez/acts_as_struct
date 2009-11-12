class CreateStructMembers < ActiveRecord::Migration
  def self.up
    create_table "struct_members", :force => true do |t|
      t.integer :struct_id,                 :default => 0,  :null => false
      t.string  :struct_type, :limit => 50, :default => "", :null => false
      t.string  :name,        :limit => 50, :default => "", :null => false
      t.string  :value_type,  :limit => 50, :default => "", :null => false
      t.binary  :value
    end

    add_index("struct_members", ["struct_id", "struct_type", "name"],
              :name=>"struct_memebers_id_type_name_index")
  end

  def self.down
    remove_index("struct_members", :name=>"struct_memebers_id_type_name_index")
    drop_table "struct_members"
  end
end
