require 'spec_helper'

describe MoviesController do
  describe 'searching for similar movies' do
    before :each do
      @fake_similar_movies = [mock('movie3'), mock('movie4')]
      Movie.stub(:find_movies_with_same_director).and_return(@fake_similar_movies)
    end
    it 'should call the model method that finds a movie' do
      @fake_movie = mock(:title => 'movie1', :director => 'director1')
      Movie.should_receive(:find_by_id).with('1').and_return(@fake_movie)
      post :similar_movies, { :id => 1 }
    end
    it 'should check if movie has director info' do
      @fake_movie = double(:title => 'movie1', :director => 'director1')
      Movie.stub(:find_by_id).and_return(@fake_movie)
      @fake_movie.should_receive(:director)
      post :similar_movies, { :id => 1 }
    end
    describe 'for a movie with director info' do
      before :each do
        @fake_movie = mock(:title => 'movie1', :director => 'director1')
        Movie.stub(:find_by_id).and_return(@fake_movie)
      end
      it 'should call the model method that performs similar movies search' do
        Movie.should_receive(:find_movies_with_same_director).with('1')
        post :similar_movies, { :id => 1 }
      end
      it 'should select the Similar Movies template for rendering' do
        post :similar_movies, { :id => 1 }
        response.should render_template('similar_movies')
      end
      it 'should make the movie and the similar movies search results available to that template' do
        post :similar_movies, { :id => 1 }
        assigns(:movie).should == @fake_movie
        assigns(:similar_movies).should == @fake_similar_movies
      end
    end
    describe 'for a movie without director info' do
      before :each do
        @fake_movie = mock(:title => 'movie1', :director => '')
        Movie.stub(:find_by_id).and_return(@fake_movie)
      end
      it 'should not call the model method that performs similar movies search' do
        Movie.should_not_receive(:find_movies_with_same_director)
        post :similar_movies, { :id => 1 }
      end
      it 'should redirect to the index page' do
        post :similar_movies, { :id => 1 }
        response.should redirect_to(movies_path)
      end
      it 'should flash a message that the movie has no director info' do
        post :similar_movies, { :id => 1 }
        flash[:notice].should == "'%s' has no director info" % @fake_movie.title
      end
    end
  end
end
