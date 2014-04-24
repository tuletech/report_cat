module SetupReports

  include ReportCat::Core

  def setup_reports
    @report = Report.new( :name => :test )

    @report.add_param( :check_box_test, :check_box, false )
    @report.add_param( :date_test, :date, Date.civil( 2013, 9, 16 ) )
    @report.add_param( :hidden_test, :check_box, true, :hidden => true )
    @report.add_param( :select_test, :select, 1, :values => [ 1, 2, 3 ] )
    @report.add_param( :text_field_test, :text_field )

    @report.add_column( :day, :date )
    @report.add_column( :total, :integer )

    @report.add_chart( :pie_test, :pie, :day, :total )
    @report.add_chart( :bar_test, :bar, :day, :total )
    @report.add_chart( :line_test, :line, :day, :total )

    @report.rows[ 0 ] = [ '2013-09-17', 27 ]
    @report.rows[ 1 ] = [ '2013-09-18', 270 ]

    @reports = HashWithIndifferentAccess.new
    @reports[ @report.name.to_sym ] = @report
  end

end