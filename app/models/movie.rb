class Movie < ActiveRecord::Base
  has_and_belongs_to_many :directors
  has_and_belongs_to_many :actors
  
  has_attached_file :cover, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  attr_accessor :amazon_attributes
  
end
