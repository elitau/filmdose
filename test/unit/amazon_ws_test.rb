require File.dirname(__FILE__) + '/../test_helper'

class AmazonWsTest < ActiveSupport::TestCase

  def setup
    $TESTING = true
    @search_key = 'Rocky'
    @amazon_ws = AmazonWs.new(@search_key)
  end
  
  def test_search
    assert results = @amazon_ws.search
    assert_kind_of Array, results
    assert_kind_of Movie, results.first
    
    assert_match /#{@search_key.downcase}/, results.first.title.downcase
  end
  
  def test_invoke_amazon_search
    assert results = @amazon_ws.invoke_amazon_search
    assert_kind_of Amazon::AWS::AWSObject, results
  end
  
  def test_movie_factory
    assert results = @amazon_ws.invoke_amazon_search
    assert movies = @amazon_ws.movie_factory(results)
    assert_kind_of Array, movies
    assert_kind_of Movie, movies.first
    assert_match /#{@search_key.downcase}/, movies.first.title.downcase
  end
  
end