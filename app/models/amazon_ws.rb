include Amazon::AWS
include Amazon::AWS::Search

class AmazonWs
  
  attr_reader :search_key
  attr_reader :results
  
  def initialize(key)
    @search_key = key
  end
  
  def search
    amazon_results = invoke_amazon_search
    @results = movie_factory(amazon_results)
  end
  
  private unless $TESTING
  
  def invoke_amazon_search
    is = ItemSearch.new( 'Video', { 'Title' => @search_key } )
    rg = ResponseGroup.new( 'Small' )
    req = Request.new('03DWX6NDEKTZN8XS7TG2', 'filmdose-20')
    req.locale = 'de'
    resp = req.search(is, rg)
    resp
  end
  
  def movie_factory(search_results)
    found_movies = []
    movies = search_results.item_search_response.items.item
    movies.each do |movie|
      found_movies << get_movie(movie)
    end
    found_movies
  end
  
  def get_movie(movie)
    movie_attributes = movie.item_attributes
    Movie.new(get_movie_attributes(movie_attributes))

    
    # results['item_search_response'].items.item.items
    #     was kann zurueck kommen:
    #      - AWSArray oder AWSObject
    #      
    #     gibbet die mehtode properties, die die inhalte enthaeut
    #     
  end
  
  def get_movie_attributes(attributes)
    title = attributes.title.to_s # oder Alle aus array nehmen
    { :title => title }
  end
end