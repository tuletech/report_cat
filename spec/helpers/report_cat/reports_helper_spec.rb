describe ReportCat::ReportsHelper do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  #############################################################################
  # report_back

  describe '#report_back' do

    context 'when back is set' do

      it 'returns a link to the back report' do
        @report.back = { :name => :user_report }
        expected = "<a href=\"/report_cat/reports/user_report\">User Report</a>"
        expect( helper.report_back( @report ) ).to eql( expected )
      end
    end

    context 'when back is not set' do

      it 'returns a link to the report root path' do
        @report.back = nil
        expected = "<a href=\"/\">Reports</a>"
        expect( helper.report_back( @report ) ).to eql( expected )
      end
    end
  end

  #############################################################################
  # report_chart_partial

  describe '#report_chart_partial' do

    it 'renders the google charts partial' do
      expect( helper ).to receive( :render ).with( :partial => 'report_cat/reports/google_charts' )
      helper.report_chart_partial
    end
  end

  #############################################################################
  # report_charts

  describe '#report_charts' do

    it 'renders the configured charts' do
      expect( helper.report_charts( @report ) ).to eql_file( 'spec/data/helpers/report_charts.html' )
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
      expect( helper.report_csv_link( @report ) ).to eql( expected )
    end
  end

  #############################################################################
  # report_description

  describe '#report_description' do

    it 'renders the localized description for the report' do
      expected = t( :description, :scope => [ :report_cat, :instances, @report.name.to_sym ] )
      expect( helper.report_description( @report ) ).to eql( expected )
    end
  end

  #############################################################################
  # report_form

  describe '#report_form' do

    it 'renders a form for the report params' do
      pending 'broken on Travis in a non-obvious way.  need build artifact. http://blog.travis-ci.com/2012-12-18-travis-artifacts/ '
      expect( helper ).to receive( :report_path ).and_return( '' )
      expect( helper.report_form( @report ) ).to eql_file( 'spec/data/helpers/report_form.html' )
    end
  end

  #############################################################################
  # report_form_param

  describe '#report_form_param' do

    it 'returns a div with the form element' do
      param = @report.param( :check_box_test )
      expect( helper.report_form_param( param ) ).to eql_file( 'spec/data/helpers/report_form_param.html' )
    end

    it 'returns hidden params' do
      param = @report.param( :hidden_test )
      expected = "<input type=\"hidden\" name=\"hidden_test\" id=\"hidden_test\" value=\"true\" />"
      expect( helper.report_form_param( param ) ).to eql( expected )
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
      expect( helper.report_list( @reports ) ).to eql_file( 'spec/data/helpers/report_list.html' )
    end
  end

  #############################################################################
  # report_name

  describe '#report_name' do

    it 'renders the localized description for the report' do
      expected = t( :name, :scope => [ :report_cat, :instances, @report.name.to_sym ] )
      expect( helper.report_name( @report ) ).to eql( expected )
    end
  end

  #############################################################################
  # report_param

  describe '#report_param' do

    it 'returns a checkbox' do
      param = @report.param( :check_box_test )
      path = 'spec/data/helpers/report_param_checkbox.html'
      expect( report_param( param ) ).to eql_file( path )
    end

    it 'returns a date' do
      param = @report.param( :date_test )
      path = 'spec/data/helpers/report_param_date.html'
      expect( report_param( param ) ).to eql_file( path )
    end

    it 'returns a hidden' do
      param = @report.param( :hidden_test )
      path = 'spec/data/helpers/report_param_hidden.html'
      expect( report_param( param ) ).to eql_file( path )
    end

    it 'returns a select' do
      param = @report.param( :select_test )
      path = 'spec/data/helpers/report_param_select.html'
      expect( report_param( param ) ).to eql_file( path )
    end

    it 'returns a text_field' do
      param = @report.param( :text_field_test )
      path = 'spec/data/helpers/report_param_text_field.html'
      expect( report_param( param ) ).to eql_file( path )
    end

    it 'raises an exception for unknown types' do
      param = Param.new( :name => :foo, :type => :bar )
      expect { report_param( param ) }.to raise_error
    end

    #############################################################################
    # report_table

    describe '#report_table' do

      it 'renders a table of report rows' do
        expect( report_table( @report ) ).to eql_file( 'spec/data/helpers/report_table.html' )
      end

      it 'excludes hidden columns'do
        @report.column( :day ).options[ :hidden ] = true
        @report.column( :total ).options[ :hidden ] = true
        expect( report_table( @report ) ).to eql_file( 'spec/data/helpers/report_table_hidden.html' )
      end
    end
  end
end