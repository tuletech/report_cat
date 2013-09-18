require 'spec_helper'

describe ReportCat::ReportsHelper do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  describe '#report_chart_partial' do

    it 'renders the google charts partial' do
      helper.should_receive( :render ).with( :partial => 'report_cat/reports/google_charts' )
      helper.report_chart_partial
    end

  end

  describe '#report_charts' do

    it 'renders the configured charts' do
      helper.report_charts( @report ).should eql_file( 'spec/data/helpers/report_charts.html' )
    end

  end

  describe '#report_csv_link' do

    it 'renders a CSV link' do
      expected = "<a href=\"/\">Export as CSV</a>"
      helper.should_receive( :report_path ).with( @report.name, :format => 'csv' ).and_return( '/' )
      helper.report_csv_link( @report ).should eql( expected )
    end

  end

  describe '#report_list' do

    it 'renders a list of reports in HTML' do
      report_list( @reports ).should eql_file( 'spec/data/helpers/report_list.html' )
    end

  end

  describe '#report_param' do

    it 'returns a checkbox' do
      param = @report.param( :check_box_test )
      path = 'spec/data/helpers/report_param_checkbox.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a date' do
      param = @report.param( :date_test )
      path = 'spec/data/helpers/report_param_date.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a hidden' do
      param = @report.param( :hidden_test )
      path = 'spec/data/helpers/report_param_hidden.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a select' do
      param = @report.param( :select_test )
      path = 'spec/data/helpers/report_param_select.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a text_field' do
      param = @report.param( :text_field_test )
      path = 'spec/data/helpers/report_param_text_field.html'
      report_param( param ).should eql_file( path )
    end

    it 'raises an exception for unknown types' do
      param = Param.new( :name => :foo, :type => :bar )
      lambda { report_param( param ) }.should raise_error
    end

  end
end