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
    amazon_results = AmazonWs.invoke_amazon_search(operation)
    @results = AmazonWs.movie_factory(amazon_results)
  end

  def self.find_by_amazon_id(amazon_id)
    operation = ItemLookup.new( 'ASIN', { 
            'ItemId' => amazon_id,
            'MerchantId' => 'Amazon' 
           })
    amazon_results = AmazonWs.invoke_amazon_search(operation)
    @results = AmazonWs.movie_factory(amazon_results).first
  end
  
  
  # private unless $TESTING
  
  def self.invoke_amazon_search(operation)
    rg = ResponseGroup.new( 'Small' )
    request = Request.new('03DWX6NDEKTZN8XS7TG2', 'filmdose-20',  'de')
    # request.locale = 'de'
    response = request.search(operation, rg)
    return response
  end
  
  def self.movie_factory(search_results)
    found_movies = []
    # This distiguish is needed because the response type varies by search type
    movies = (search_results.item_search_response || search_results.item_lookup_response).items.item
    movies.each do |movie|
      found_movies << AmazonWs.get_movie(movie)
    end
    found_movies
  end

  def self.get_movie(movie)
    movie_amazon_attributes = movie.item_attributes
    title = AmazonWs.get_movie_attribute('title', movie_amazon_attributes)
    amazon_id = AmazonWs.get_amazon_id(movie)
    # Get an array with names of the directors
    # directors = get_movie_director(movie_amazon_attributes)
    movie = Movie.new(:title => title)
    movie.amazon_id = amazon_id
    movie.amazon_attributes = movie_amazon_attributes
    # movie.directors.create()
    return movie
  end

  
  def self.method_missing(method_name, *args)
    if attribute =~ /get_movie_(.*)/
      get_movie_attribute(attribute, *args)
    else
      super(method_name, *args)
    end
  end
  
  def self.get_amazon_id(movie)
    return movie.asin.to_s
  end
  
  def self.get_movie_attribute(which_attribute, amazon_attributes)
    attributes_array = amazon_attributes.send(which_attribute)
    attributes_array.collect(&:to_s) # same as {|att| att.to_s}
    # title = attributes.title.to_s # oder Alle aus array nehmen
    # director = attributes.director.collect
    # { :title => title, :directors =>  }
    # return title, [Director.new(:name => director)]
    return attributes_array.collect(&:to_s).join("--")
  end
end