class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_movies_with_same_director(id)
    movie = find_by_id(id)
    where("director = ?", movie.director)
  end
end
