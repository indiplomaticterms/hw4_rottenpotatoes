Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.find_or_create_by_title(movie)
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  movie = Movie.find_by_title(title)
  movie.director.should == director
end

