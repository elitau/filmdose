include Amazon::AWS
include Amazon::AWS::Search

class AmazonWs
  # def initialize
  #   super
  # end
  
  def self.search(key)
    [Movie.new]
  end
  
  private unless $TESTING
  
  def self.invoke_amazon_search(key)
    is = ItemSearch.new( 'Video', { 'Title' => 'Herr der Ringe' } )
    rg = ResponseGroup.new( 'Small' )
    req = Request.new('03DWX6NDEKTZN8XS7TG2', 'filmdose-20')
    req.locale = 'de'
    resp = req.search(is, rg)
    resp
  end
end