class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # puts params.inspect
    # puts params[:commit]
    # puts params[:ratings].nil?
    # puts session[:sort]
    # puts session[:select_ratings]

    @all_ratings = ['G','PG','PG-13','R','NC-17']
    #store ratings
    if params[:commit] == 'Refresh' && params[:ratings].nil?
      select_ratings = {}
      session[:select_ratings] = select_ratings
    elsif params[:ratings].nil? && session[:select_ratings].nil?
      select_ratings = Movie.all_ratings
    elsif !params[:ratings].nil?
      session[:select_ratings] = params[:ratings]
      select_ratings = params[:ratings]
    else
      select_ratings = session[:select_ratings]
    end
    puts select_ratings
    #store sorts
    if !params[:sort].nil?
      session[:sort] = params[:sort]
      select_sort = params[:sort]
    else
      select_sort = session[:sort]
    end

    @select_ratings = select_ratings
    @sort = select_sort

    if select_sort == 'title'
      @movies = Movie.where(:rating => select_ratings.keys).order(:title => :asc)
    elsif select_sort == 'release_date'
      @movies = Movie.where(:rating => select_ratings.keys).order(:release_date => :asc)
    else
      @movies = Movie.where(:rating => select_ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
