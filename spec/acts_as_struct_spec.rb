# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'spec_helper')
require 'json'

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

class Article < Post
  acts_as_struct
  struct_member :json, JSON, :default => { }
  struct_member :yaml, YAML, :default => { }
end

class News < Post
  acts_as_struct
  struct_member(:block, JSON, :default => { }) do |name, value_type, options|
    define_method("#{name}?") do
      struct_members.map(&:name).include?(name)
    end
  end
  struct_member(:noblock, JSON, :default => { })
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
  describe "JSON/YAML" do
    describe "default value" do
      subject{ Article.create!(:name => 'name')}
      its(:json){ should == { } }
      its(:yaml){ should == { } }
    end
    describe "set json value" do
      before do
        @article = Article.create!(:name => 'name')
        @article.json = { :a => 1, :b => 2, :c => { :d => :e } }
        @article.save!
      end
      it "json" do
        @article.reload
        @article.json.should == { "a" => 1, "b" => 2, "c" => { "d" => "e" } }
      end
    end
    describe "set yaml value" do
      before do
        @article = Article.create!(:name => 'name')
        @article.yaml = { :a => 1, :b => 2, :c => { :d => :e } }
        @article.save!
      end
      it "yaml" do
        @article.reload
        @article.yaml.should == { :a => 1, :b => 2, :c => { :d => :e } }
      end
    end
  end
  describe "block" do
    describe "when do not create sub record" do
      before do
        @news = News.create!(:name => 'name')
      end
      it "returns false" do
        @news.block?.should be_false
      end
      it "raise NoMethodError" do
        lambda{ @news.noblock? }.should raise_error(NoMethodError)
      end
    end
    describe "when create sub record" do
      before do
        @news = News.create!(:name => 'name')
        @news.block = { :options => { :foo => "bar" } }
      end
      it "returns false" do
        @news.block?.should be_true
      end
    end
  end
end

