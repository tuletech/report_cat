[![Build Status](https://travis-ci.org/schrodingersbox/report_cat.svg?branch=master)](https://travis-ci.org/schrodingersbox/report_cat)
[![Coverage Status](https://coveralls.io/repos/schrodingersbox/report_cat/badge.png?branch=master)](https://coveralls.io/r/schrodingersbox/report_cat?branch=master)
[![Code Climate](https://codeclimate.com/github/schrodingersbox/report_cat.png)](https://codeclimate.com/github/schrodingersbox/report_cat)
[![Dependency Status](https://gemnasium.com/schrodingersbox/report_cat.png)](https://gemnasium.com/schrodingersbox/report_cat)
[![Gem Version](https://badge.fury.io/rb/report_cat.png)](http://badge.fury.io/rb/report_cat)

# schrodingersbox/report_cat README

A Rails engine to generate simple web-based reports with charts along with Rspec matchers for testing them.

It currently supports:

 * Simple reports
 * Date range reports
 * Date range cohort reports

It provides the following matchers:

 * have_chart
 * have_column
 * have_param

 Report subclasses will automatically appear under the ReportCat index controller,
 allowing you to add a new report with custom form, columns and charts by just adding a subclass.

## Getting Started

1. Add this to your `Gemfile` and `bundle install`

		gem 'report_cat', :git => 'https://github.com/schrodingersbox/report_cat.git'

2. Add this to your `config/routes.rb`

		mount ReportCat::Engine => '/report_cat'

3. Install and run migrations

        rake report_cat:install:migrations
        rake db:migrate

4. Restart your Rails server

5.  Visit http://yourapp/report_cat in a browser

## Background

 _TODO: UML goes here_

### Building a report



### Adding Params

add_param( name, type, value = nil, options = {} )

types = :check_box, :date, :hidden, :select, :text_field
options = :values

### Adding Columns

add_column( name, type, options = {} )

types = :date, :float, :integer, :moving_average, :ratio, :report, :string
options = :sql

### Adding Charts

add_chart( name, type, label, values, options = {} )

types = :area, :bar, :column, :line, :pie

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

3.  Or build one on the fly

    report = ReportCat::Core::Report.new( :name => :my_report, :from => :users, :order_by => 'users.id asc' )
    report.add_column( :total, :integer, :sql => 'count( users.id )' )
    report.add_chart( :chart, :line, :start_date, :total )
    report.generate
    report.rows.each { |row| puts "Total = #{row[0]} }


### Reload Reports In Development Mode

Add the following to ApplicationController:

      before_filter :require_reports if Rails.env.development?

      def require_reports
        silence_warnings do
            Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require_dependency path }
        end
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

 * Add group param to date charts to control grouping behavior
 * Better handling for hidden fields - want to hide a bool / checkbox, but lose string -> type conversion

 * Report initialize should accept joins as an array and concat them with spaces (maybe don't concat until render)

 * Replace Google Charts with D3

 * Improve Column modelling WRT calculated ratios and moving averages

 * Cleanup

 * Document
   * How To
   * Background
     * UML

