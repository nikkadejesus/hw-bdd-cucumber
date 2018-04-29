# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
  # fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1)).to be < page.body.index(e2)
  # fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split /,\s*/
  rating_list.each do |rating|
    if uncheck
      uncheck("ratings_" + rating)
    else
      check("ratings_" + rating)
    end
  end
  # fail "Unimplemented"
end

And /^(?:|I )press "([^"]*)" to filter list/ do |button|
  click_button("ratings_" + button)
end

Then /I should see movies with ratings: (.*)/ do |rating_list|
  rating_list.gsub! /,\s*/, "|"
  regexp = Regexp.new rating_list
  if page.respond_to? :should
    page.should have_xpath('//tbody/tr/td/*', :text => regexp)
  else
    assert page.has_xpath?('//tbody/tr/td/*', :text => regexp)
  end
end

And /I should not see movies with ratings: (.*)/ do |rating_list|
  rating_list.gsub! /,\s*/, "|"
  regexp = Regexp.new rating_list
  if page.respond_to? :should
    page.should have_no_xpath('//tbody/tr/td/*', :text => regexp)
  else
    assert page.has_no_xpath?('//tbody/tr/td/*', :text => regexp)
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  rows = page.all('//tbody/tr').count
  expect(rows).to eq Movie.count
  # fail "Unimplemented"
end
