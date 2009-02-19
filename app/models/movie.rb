class Movie < ActiveRecord::Base
  has_and_belongs_to_many :directors
  attr_accessor :amazon_attributes
  
end
