class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date,)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Getting all the movies from MODEL
    @all_ratings = Movie.ratings_all
    
    sort_type = params[:inorder]
    ratings_list = params[:ratings]
    
    #if sort was requested, then save it in session
    session[:inorder] = sort_type unless sort_type.nil?
    
    #Save boxes that are pressed in session
    session[:ratings] = ratings_list unless ratings_list.nil?
    
    if(sort_type and ratings_list)
      @movies = Movie.where(rating: (params[:ratings].keys)).order(session[:inorder])
    elsif(sort_type and !ratings_list)
      @movies = Movie.all.order(session[:inorder])
    elsif(ratings_list)
      @movies = Movie.where(rating: (params[:ratings].keys)).order(session[:inorder])
    elsif(sort_type and session[:ratings] and !ratings_list)
      @movies = Movie.where(rating: (session[:ratings].keys)).order(sort_type)
    elsif((session[:ratings] and !ratings_list) or (session[:inorder] and !sort_type))
      redirect_to movies_path("ratings" => session[:ratings], "inorder" => session[:inorder])
    elsif(session[:ratings] or session[:inorder])
      redirect_to movies_path("ratings" => session[:ratings], "inorder" => session[:inorder])
    else
      @movies = Movie.all
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
