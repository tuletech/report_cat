require 'spec_helper'

describe ReportCat::ReportsHelper do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  describe 'report_param' do

    it 'returns a checkbox' do
      param = @report.param( :check_box_test )
      path = 'spec/data/report_param_checkbox.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a date' do
      param = @report.param( :date_test )
      path = 'spec/data/report_param_date.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a hidden' do
      param = @report.param( :hidden_test )
      path = 'spec/data/report_param_hidden.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a select' do
      param = @report.param( :select_test )
      path = 'spec/data/report_param_select.html'
      report_param( param ).should eql_file( path )
    end

    it 'returns a text_field' do
      param = @report.param( :text_field_test )
      path = 'spec/data/report_param_text_field.html'
      report_param( param ).should eql_file( path )
    end

    it 'raises an exception for unknown types' do
      param = Param.new( :name => :foo, :type => :bar )
      lambda { report_param( param ) }.should raise_error
    end

  end
end