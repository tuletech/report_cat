require 'spec_helper'

describe ReportCat::ReportsHelper do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  #############################################################################
  # report_chart_partial

  describe '#report_chart_partial' do

    it 'renders the google charts partial' do
      helper.should_receive( :render ).with( :partial => 'report_cat/reports/google_charts' )
      helper.report_chart_partial
    end

  end

  #############################################################################
  # report_charts

  describe '#report_charts' do

    it 'renders the configured charts' do
      helper.report_charts( @report ).should eql_file( 'spec/data/helpers/report_charts.html' )
    end

  end

  #############################################################################
  # report_count

  describe '#report_count' do

    it 'returns a translated count string' do
      expected = I18n.t( :count, :scope => :report_cat, :count => @report.rows.count )
      expect( helper.report_count( @report ) ).to eql( expected )
    end

  end

  #############################################################################
  # report_csv_link

  describe '#report_csv_link' do

    it 'renders a CSV link' do
      url = '/foo/bar?format=csv'
      expect( helper ).to receive( :url_for ).with( { :params => { :format => :csv } } ).and_return( url )
      expected = "<a href=\"#{url}\">Export as CSV</a>"
      helper.report_csv_link( @report ).should eql( expected )
    end

  end

  #############################################################################
  # report_description

  describe '#report_description' do

    it 'renders the localized description for the report' do
      expected = t( :description, :scope => [ :report_cat, :instances, @report.name.to_sym ] )
      helper.report_description( @report ).should eql( expected )
    end

  end

  #############################################################################
  # report_form

  describe '#report_form' do

    before( :each ) do
      helper.should_receive( :report_path ).and_return( '' )
    end

    it 'renders a form for the report params' do
      helper.report_form( @report ).should eql_file( 'spec/data/helpers/report_form.html' )
    end

  end

  #############################################################################
  # report_link

  describe '#report_link' do

    it 'generates a link to a report' do
      attributes = { :name => :cohort_report, :is_cohort => '1' }
      expected =  "<a href=\"/report_cat/reports/cohort_report?is_cohort=1\">Cohort Report</a>"
      expect( helper.report_link( attributes ) ).to eql( expected )
    end

  end

  #############################################################################
  # report_list

  describe '#report_list' do

    it 'renders a list of reports in HTML' do
      report_list( @reports ).should eql_file( 'spec/data/helpers/report_list.html' )
    end

  end

  #############################################################################
  # report_name

  describe '#report_name' do

    it 'renders the localized description for the report' do
      expected = t( :name, :scope => [ :report_cat, :instances, @report.name.to_sym ] )
      helper.report_name( @report ).should eql( expected )
    end

  end

  #############################################################################
  # report_param

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
      pending 'is broken on Travis CI'

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

    #############################################################################
    # report_table

    describe '#report_table' do

      it 'renders a table of report rows' do
        report_table( @report ).should eql_file( 'spec/data/helpers/report_table.html' )
      end

      it 'excludes hidden columns'

    end

  end
end