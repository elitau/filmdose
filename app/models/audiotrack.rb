class Audiotrack < ActiveRecord::Base
  has_and_belongs_to_many :movies
end
