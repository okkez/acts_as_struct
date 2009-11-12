# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'spec_helper')

class Person < ActiveRecord::Base
  acts_as_struct
  struct_member :nickname, :string
  struct_member :salary, :integer
  struct_member :married, :boolean, :default => false
  struct_member :note, :string, :default => 'note'
end

class Place < ActiveRecord::Base
  acts_as_struct
  struct_member :population, :integer, :default => 100

  attr_accessor :note

  def after_save
    self.note = 'note'
  end
end

class Post < ActiveRecord::Base
  acts_as_struct
  struct_member :note, :string, :default => 'note'
  attr_accessor :dummy
  after_save :set_dummy
  private
  def set_dummy
    self.dummy = 'dummy'
  end
end

class CommentCallback
  def after_save(record)
    record.dummy = 'dummy'
  end
end

class Comment < ActiveRecord::Base
  acts_as_struct
  struct_member :note, :string, :default => 'note'
  attr_accessor :dummy
  after_save CommentCallback.new
end

describe Nifty::Acts::Struct do
  describe "save struct member" do
    before do
      @person = Person.create!(:name => 'name', :age => 20)
      @person.nickname = 'nickname'
    end
    it "do not raise error" do
      lambda{ @person.save! }.should_not raise_error
    end
  end
  describe "save struct members" do
    before do
      @person = Person.create!(:name => 'name', :age => 20)
      @person.nickname = 'nickname'
      @person.salary = 100
      @person.married = true
    end
    it "do not raise error" do
      lambda{ @person.save! }.should_not raise_error
    end
  end
  describe Person, "with default value" do
    subject{ Person.create!(:name => 'name', :age => 20) }
    its(:name){ should == 'name' }
    its(:age){ should == 20 }
    its(:nickname){ should be_empty }
    its(:salary){ should == 0 }
    its(:married){ should be_false }
    its(:note){ should == 'note' }
  end
  describe "callbacks" do
    describe Place do
      subject{ Place.create(:name => 'name') }
      its(:population){ should == 100 }
      its(:note){ should == 'note' }
    end
    describe Post do
      subject{ Post.create!(:name => 'name') }
      its(:note){ should == 'note' }
      its(:dummy){ should == 'dummy' }
    end
    describe Comment do
      subject{ Comment.create!(:name => 'name') }
      its(:note){ should == 'note' }
      its(:dummy){ should == 'dummy' }
    end
  end
end

