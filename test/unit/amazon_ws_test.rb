require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class AmazonWsTest < ActiveSupport::TestCase

  def setup
    $TESTING = true
    @search_key = 'dark knight'
  end
  
  def test_search
    assert results = AmazonWs.find_by_title(@search_key)
    assert_kind_of Array, results
    assert_kind_of Movie, results.first
    assert_not_nil first_result = results.first
    assert_not_nil first_result.title
    assert_match /#{@search_key.downcase}/, first_result.title.downcase
  end
  
  # def test_invoke_amazon_search
  #     assert results = @amazon_ws.invoke_amazon_search
  #     assert_kind_of Amazon::AWS::AWSObject, results
  #   end
  #   
  def test_movie_factory
    results = mock_amazon_search_results(@search_key, "amazon_id")
    assert movies = AmazonWs.movie_factory(results)
    assert_kind_of Array, movies
    assert_kind_of Movie, movies.first
    assert_match /#{@search_key.downcase}/, movies.first.title.downcase
    assert movies.first.amazon_id

    movies.each do |movie|
      assert_match /#{@search_key.downcase}/, movie.title.downcase
      # assert !movie.directors.blank?
    end
  end
  
  def test_find_by_amazon_id
    amazon_id = movies(:rocky).amazon_id
    amazon_results = mock_amazon_search_results("Rocky", movies(:rocky).amazon_id)
    AmazonWs.expects(:invoke_amazon_search).returns(amazon_results)

    selected_movie = AmazonWs.find_by_amazon_id(amazon_id)
    assert_kind_of Movie, selected_movie
  end
  
  def mock_amazon_search_results(title, amazon_id)
    mock = mock('results_mock')
    # mock.stubs(:title => title)
    item_attributes = stub("item_attributes", :title => title)
    item_attributes.stubs(:director => "Some Director")
    item_attributes.stubs(:actor => "Some Actor")
    item = stub('item', :item_attributes => item_attributes, :asin => amazon_id)
    
    image = mock("image_mock")
    image.stubs(:get => File.open(File.dirname(__FILE__) + '/../assets/tester.jpg'))
    item.stubs(:large_image => image)
    items = [item, item]
    items.stubs(:item => item)
    search_response = stub("search_response")
    search_response.stubs(:items => search_response, :item => items)
    mock.stubs(:item_search_response => search_response)
    mock.stubs(:empty? => false)
    mock
  end
  
end