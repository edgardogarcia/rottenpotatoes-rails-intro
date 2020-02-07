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
    session[:inorder] = sort_type unless !sort_type
    
    #Save boxes that are pressed in session
    session[:ratings] = rating_list unless !ratings_list
    
    if(sort_type or ratings_list)
      if(!ratings_list)
        @movies = Movie.all.order(session[:inorder])
      else
        @movies = Movie.where(rating: (params[:ratings].keys)).order(session[:inorder])
      end
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
