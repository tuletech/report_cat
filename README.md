# schrodingersbox/report_cat README

A Rails engine to generate simple web-based reports with charts

## Getting Started

1. Add this to your `Gemfile` and `bundle install`

		gem 'report_cat', :git => 'https://github.com/schrodingersbox/report_cat.git'

2. Add this to your `config/routes.rb`

		mount ReportCat::Engine => '/report_cat'

3. Install and run migrations

        rake report_cat:install:migrations
        rake db:migrate

4. Restart your Rails server

5.  Visit http://yourapp/report_cat in a browser for an HTML meter report

 ## Background

 _TODO: UML goes here_

## How To

### Add New Reports

You can place new reports anywhere you like, but `app/reports` is the recommended location.

1.  Add the following to `config/application.rb`

    	Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require path }

2.  Create a subclass of `ReportCat::Core::Report`, `ReportCat::Report::DateRangeReport` or `ReportCat::Report::CohortReport`

    class MyReport << ReportCat::Report::DateRangeReport

        def initialize
            super( :name => :my_report, :from => :users, :order_by => 'users.id asc' )
            add_column( :total, :integer, :sql => 'count( users.id )' )
            add_chart( :chart, :line, :start_date, :total )
        end
    end

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

 * Externalize all strings (maybe already there)
 * Matchers to help with speccing charts ... have_param, have_column, have_chart
 * Improve Column modelling WRT calculated ratios and moving averages

 * Cleanup

 * Document
   * How To
   * Background
     * UML

