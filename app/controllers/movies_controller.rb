class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml

  def index
    @movies = Movie.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  def auto_complete_for_movie_title
    @items = AmazonWs.find_by_title(params[:q]).collect(&:title)
    render :text => @items.join("\n")
  end
  
  def auto_complete_for_movie_details
    @items = AmazonWs.find_by_title(params[:q])
    @movie = AmazonWs.find_by_amazon_id(@items.first.amazon_id)
    # @movie.save
    # session[:movie] = @movie
    render :partial => "selected_movie", :locals => { :movie => @items.first } 
  end

  # POST /movies
  # POST /movies.xml
  def create
    # @movie = session[:movie]
    @movie = AmazonWs.find_by_amazon_id(params[:amazon_id])
    @movie.title = params[:movie][:title]
    respond_to do |format|
      if @movie.save
        flash[:notice] = 'Movie was successfully created.'
        format.html { redirect_to(@movie) }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
    session[:movie] = nil
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(@movie) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
end
