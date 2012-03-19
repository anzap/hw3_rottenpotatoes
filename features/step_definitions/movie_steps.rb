# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  count = 0
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
    count=count+1
  end
  assert (Movie.count==count), "Movies are not saved properly to database"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = Regexp.new ".*#{e1}.*#{e2}"
  # assert page.body.should =~ regexp, "Not sorted alphabetically"
  assert /.*#{e1}.*#{e2}/m.match(page.body), "Not sorted alphabetically"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    When %Q{I #{uncheck}check "ratings[#{rating.strip}]"}
  end
end

Then /I should see (all of the|no)? movies/ do |test|
  if test=="all of the"
    assert (page.body.scan(/<tr\b[^>]*>(.*?)<\/tr>/m).size-1==Movie.count), "Not all movies are shown in the page"
  elsif test=="no"
    assert (page.body.scan(/<tr\b[^>]*>(.*?)<\/tr>/m).size-1==0), "Movies are shown in the page"
  end 
end

