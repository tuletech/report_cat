module ReportCat
  module ReportsHelper

    def report_chart_name( report, chart )
      t( chart.name.to_sym, :scope => [ :report_cat, :charts ] )
    end


    def report_chart_partial
      render :partial => 'report_cat/reports/google_charts'
    end

    def report_charts( report )
      output = ''

      report.charts.each do |chart|
        output += content_tag( :div, '', :class => :chart,
                           :name => report_chart_name( report, chart ),
                           :chart => chart.type,
                           :columns => chart.columns( report ),
                           :data => chart.data( report ),
                           :options => chart.options.to_json )
      end

      output
    end

    def report_count( report )
      t( :count, :scope => :report_cat, :count => report.rows.count )
    end

    def report_csv_link( report )
      link_to t( :export_as_csv, :scope => :report_cat ), :params => params.merge( :format => :csv )
    end

    def report_description( report )
      t( :description, :scope => [ :report_cat, :instances, report.name.to_sym ] )
    end

    def report_form( report )
      form_tag report_path( report.name ), :method => :get do
        @report.params.each do |param|
          name =  t( param.name, :scope => [ :report_cat, :params ] )
          concat content_tag( :div, label_tag( name ) + report_param( param ) )
        end
        concat submit_tag( t( :report, :scope => :report_cat ) )
      end
    end

    def report_link( attributes )
      attributes = attributes.dup
      attributes[ :id ] = name = attributes.delete( :name )
      link_to t( :name, :scope => [ :report_cat, :instances, name ] ), report_cat.report_path( attributes )
    end

    def report_list( reports )
      content_tag( :ul ) do
        reports.values.sort { |a,b| a.name <=> b.name }.each do |report|
          unless ReportCat.config.excludes.include?( report.class )
            link = link_to( report_name( report ), { :controller => :reports, :action => :show, :id => report.name } )
            concat content_tag( :li, link + ' - ' + report_description( report ) )
          end
        end
      end
    end

    def report_name( report )
      t( :name, :scope => [ :report_cat, :instances, report.name.to_sym ] )
    end

    def report_param( param )
      case param.type
        when :check_box  then return check_box_tag( param.name, '1', param.value )
        when :date       then return select_date( param.value, :prefix => param.name )
        when :hidden     then return hidden_field_tag( param.name, param.value ) + param.value.to_s
        when :select     then return select_tag( param.name, options_for_select( param.options[ :values ], param.value ) )
        when :text_field then return text_field_tag( param.name, param.value )
        else
          raise "Unknown param: #{param.type}"
      end
    end

    def report_table( report )
      content_tag( :table, :border => 1 ) do
        output = content_tag( :tr ) do
          report.columns.each do |column|
            concat content_tag( :th, column.name.to_s )
          end
        end

        report.rows.each do |row|
          output += content_tag( :tr ) do
            row.each_index do |index|
              data = row[ index ]
              data = report_link( data ) if ( :report == report.columns[ index ].type )
              concat content_tag( :td, data )
            end
          end
        end

        output
      end
    end

  end
end
