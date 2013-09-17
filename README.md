# schrodingersbox/report_cat README


## How To

### Add New Reports

You can place new reports anywhere you like, but `app/reports` is the recommended location.

1.  Add the following to `config/application.rb`

    	Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require path }


## Reference

 * [Getting Started with Engines](http://edgeguides.rubyonrails.org/engines.html)
 * [Testing Rails Engines With Rspec](http://whilefalse.net/2012/01/25/testing-rails-engines-rspec/)
 * [How do I write a Rails 3.1 engine controller test in rspec?](http://stackoverflow.com/questions/5200654/how-do-i-write-a-rails-3-1-engine-controller-test-in-rspec)
 * [Best practice for specifying dependencies that cannot be put in gemspec?](https://groups.google.com/forum/?fromgroups=#!topic/ruby-bundler/U7FMRAl3nJE)
 * [Clarifying the Roles of the .gemspec and Gemfile](http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/)
 * [The Semi-Isolated Rails Engine](http://bibwild.wordpress.com/2012/05/10/the-semi-isolated-rails-engine/)
 * [Shoulda](https://github.com/thoughtbot/shoulda-matchers)

# TODO

 * Core models
   * Report#to_csv
   * Report#to_sql

 * Controller / view implementation
   * HTML => helpers

 * Cleanup
   * Externalize strings

 * Document
   * Getting Started
   * How To
   * Background
     * UML

