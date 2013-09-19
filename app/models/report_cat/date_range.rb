module ReportCat
  class DateRange < ActiveRecord::Base

    #############################################################################
    # ::generate

    def self.generate( period, start_date, stop_date )
      sql = [
          sql_intersect( start_date, stop_date ),
          sql_period( period )
      ].join( ' and ' )
      date_ranges = {}
      DateRange.where( sql ).each { |d| date_ranges[ d.start_date ] = true }

      iterate( period, start_date, stop_date ) do |start_date, stop_date|
        unless date_ranges[ start_date ]
          DateRange.create( :period => period, :start_date => start_date, :stop_date => stop_date )
        end
      end
    end

    #############################################################################
    # ::iterate

    def self.iterate( period, start_date, stop_date )
      start_date = Date.parse( start_date ) if start_date.is_a?( String )
      stop_date = Date.parse( stop_date ) if stop_date.is_a?( String )

      while( start_date <= stop_date )
        case period
          when :daily
            next_date = start_date
          when :weekly
            start_date = start_date.beginning_of_week
            next_date  = start_date.end_of_week
          when :monthly
            start_date = start_date.beginning_of_month
            next_date  = start_date.end_of_month
          when :quarterly
            start_date = start_date.beginning_of_quarter
            next_date  = start_date.end_of_quarter
          when :yearly
            start_date = start_date.beginning_of_year
            next_date  = start_date.end_of_year
          else
            raise "Unknown date range: #{period}"
        end

        yield start_date, next_date

        start_date = next_date + 1
      end
    end

    #############################################################################
    # ::join_*

    def self.join_to( table, column )
      "join #{table} on date( #{column} ) between #{table_name}.start_date and #{table_name}.stop_date"
    end

    def self.join_before( table, column )
      "join #{table} on date( #{column} ) <= #{table_name}.stop_date"
    end

    def self.join_after( table, column )
      "join #{table} on date( #{column} ) > #{table_name}.stop_date"
    end

    #############################################################################
    # ::sql_*

    def self.sql_intersect( start_date, stop_date )
      sql =<<-EOSQL
        (
          #{table_name}.start_date between '#{start_date}' and '#{stop_date}'
          or
          '#{start_date}' between #{table_name}.start_date and #{table_name}.stop_date
        )
      EOSQL
    end

    def self.sql_period( period )
      "#{table_name}.period = '#{period}'"
    end

  end
end

