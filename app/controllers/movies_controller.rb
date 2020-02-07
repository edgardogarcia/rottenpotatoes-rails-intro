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
    @all_ratings = Movie.ratings_all
    
    sort_type = params[:inorder]
    ratings_list = params[:ratings]
    
    #if sort was requested, then save it in session
    if(sort_type)
      session[:inorder] = sort_type
    end
    #Save boxes that are pressed in session
    # if(ratings_type)
    #   session[:ratings] = ratings_list
    # end
    
    
    # if(session[:ratings] and ratings_list)
    #   if(session[:inorder])
    #     @movies = Movie.where(session[:ratings].keys).order(session[:inorder])
    #   else
    #     @movies = Movie.where(session[:ratings].keys)
    #   end
    # elsif(session[:rating] and !ratings_list and session[:inorder])
    #   redirect_to movies_path(ratings: session[:ratings], inorder: session[:inorder])
    # else
    #   @movies = Movie.all
    # end
       @movies = Movie.all
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
