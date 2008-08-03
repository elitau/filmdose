require File.dirname(__FILE__) + '/../test_helper'

class AmazonWsTest < ActiveSupport::TestCase

  def test_search
    assert results = AmazonWs.search('rambo')
    assert_kind_of Array, results
    assert_kind_of Movie, results.first
    
    assert_equal 'rambo', results.first.title
  end
  
  def test_invoke_amazon_search
    assert results = AmazonWs.invoke_amazon_search('rambo')
    assert_kind_of Amazon::AWS::AWSObject, results
  end
  
  def test_movie_factory
    assert results = AmazonWs.invoke_amazon_search('rambo')
    assert movies = AmazonWs.movie_factory(results)
    assert_kind_of Array, movies
    assert_kind_of Movie, movies.first
  end
  
end