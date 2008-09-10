class StructMember < ActiveRecord::Base
  belongs_to :struct, :polymorphic=>true
  validates_presence_of :struct_type
  validates_presence_of :struct_id
  validates_uniqueness_of :name, :scope=>["struct_id", "struct_type"]
end
