# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #assert page.body.index(e1) < page.body.index(e2)
  if page.body.index(e1) > page.body.index(e2)
	  assert false, "#{e2} comes after #{e1}"
  end
  #assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/, /).each do |rating|
    if (uncheck.nil?)
		check("ratings[#{rating}]")
	else
		uncheck("ratings[#{rating}]")
	end
  end
end

Then /I should see (all|none) of the movies/ do |quantity|
	if quantity.eql?("all")
		#assert page.all("table#movies tbody tr").size == Movie.all.size
		if page.all("table#movies tbody tr").size != Movie.all.size
			assert false, "expected #{Movie.all.size} movies, but found #{page.all('table#movies tbody tr').size}"
		end
	else
		#assert page.all("table#movies tbody tr").size == 0
		if page.all("table#movies tbody tr").size != 0
			assert false, "expected 0 movies, but found #{page.all('table#movies tbody tr').size}"
		end
	end
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
    movie = Movie.find_by_title(title)
    movie[:director].should == "#{director}"
end

