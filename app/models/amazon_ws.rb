require 'rubygems'
require 'amazon/aws/search'
class AmazonWs

  include Amazon::AWS
  include Amazon::AWS::Search
  
  attr_reader :search_key
  attr_reader :results
  
  def initialize(key)
    @search_key = key
  end
  
  def search
    AmazonWs.find_by_title(@search_key)
  end


  def self.find_by_title(title)
    operation = ItemSearch.new( 'Video', { 'Title' => title } )
    search_results = AmazonWs.invoke_amazon_search(operation)
    @results = AmazonWs.movie_factory(search_results)
  end

  def self.find_by_amazon_id(amazon_id)
    operation = ItemLookup.new( 'ASIN', { 
            'ItemId' => amazon_id,
            'MerchantId' => 'Amazon' 
           })
    search_results = AmazonWs.invoke_amazon_search(operation, 'Medium')
    main_group = get_main_group(search_results).first
    movie = get_movie(main_group)
    movie.cover = get_image(main_group)
    return movie
    # @results = AmazonWs.movie_factory(amazon_results).first
  end
  
  
  # private unless $TESTING
  
  def self.invoke_amazon_search(operation, response_size = "Small")
    rg = ResponseGroup.new( response_size )
    request = Request.new('03DWX6NDEKTZN8XS7TG2', 'filmdose-20',  'de')
    # request.locale = 'de'
    begin
      response = request.search(operation, rg)
    rescue Amazon::AWS::Error::NoExactMatches => e
      response = []
      RAILS_DEFAULT_LOGGER.debug("No Matches found for '#{operation.params}'")
    end
    return response
  end
  
  def self.get_main_group(search_results)
    return [] if search_results.empty?
    (search_results.item_search_response || search_results.item_lookup_response).items.item
  end
  
  def self.movie_factory(search_results)
    found_movies = []
    # This distiguish is needed because the response type varies by search type
    movies = get_main_group(search_results)
    movies.each do |movie|
      found_movies << AmazonWs.get_movie(movie)
    end
    found_movies
  end

  def self.get_movie(amazon_movie)
    movie_amazon_attributes = amazon_movie.item_attributes
    movie = Movie.new
    movie.title = AmazonWs.get_movie_attribute('title', movie_amazon_attributes).to_s
    movie.amazon_id = AmazonWs.get_amazon_id(amazon_movie)
    # Get an array with names of the directors
    get_movie_attribute('director', movie_amazon_attributes).each do |name|
      movie.directors << Director.create(:name => name)
    end
    get_movie_attribute('actor', movie_amazon_attributes).each do |name|
      movie.actors << Actor.create(:name => name)
    end
    
    movie.amazon_attributes = movie_amazon_attributes
    # movie.directors.create()
    return movie
  end

  
  # def self.method_missing(method_name, *args)
  #    if attribute =~ /get_movie_(.*)/
  #      get_movie_attribute(attribute, *args)
  #    else
  #      super(method_name, *args)
  #    end
  #  end
  
  def self.get_amazon_id(movie)
    return movie.asin.to_s
  end
  
  def self.get_image(movie)
    # return StringIO.new(movie.large_image.get)
    path = nil
    tempfile = Tempfile.new("movie#{Time.now.hash}")
    tempfile.puts(movie.large_image.get)
    # Tempfile::open("movie#{Time.now.hash}") do|tempfile|
    #   tempfile.puts(movie.large_image.get)
    #   path = tempfile.path
    # end
    return tempfile
  end
  
  def self.get_movie_attribute(which_attribute, amazon_attributes)
    attributes_array = amazon_attributes.send(which_attribute)
    attribute = if attributes_array
      attributes_array.collect(&:to_s)
    else
      []
    end
    return attribute
  end
end