# schrodingersbox/report_cat README


## How To

### Add New Reports

You can place new reports anywhere you like, but `app/reports` is the recommended location.

1.  Add the following to `config/application.rb`

    	Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require path }


### Reload Reports In Development Mode

Add the following to ApplicationController:

      before_filter :require_reports if Rails.env.development?

      def require_reports
        Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require_dependency path }
      end


## Reference

 * [Getting Started with Engines](http://edgeguides.rubyonrails.org/engines.html)
 * [Testing Rails Engines With Rspec](http://whilefalse.net/2012/01/25/testing-rails-engines-rspec/)
 * [How do I write a Rails 3.1 engine controller test in rspec?](http://stackoverflow.com/questions/5200654/how-do-i-write-a-rails-3-1-engine-controller-test-in-rspec)
 * [Best practice for specifying dependencies that cannot be put in gemspec?](https://groups.google.com/forum/?fromgroups=#!topic/ruby-bundler/U7FMRAl3nJE)
 * [Clarifying the Roles of the .gemspec and Gemfile](http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/)
 * [The Semi-Isolated Rails Engine](http://bibwild.wordpress.com/2012/05/10/the-semi-isolated-rails-engine/)
 * [Shoulda](https://github.com/thoughtbot/shoulda-matchers)

# TODO

 * Add abstract flag to report
   * Date range reports
   * Cohort reports

 * Cleanup
   * Specs for ReportHelper
   * HTML => helpers
   * Externalize strings
   * Improve Column modelling WRT calculated ratios and moving averages

 * Document
   * Getting Started
   * How To
   * Background
     * UML

