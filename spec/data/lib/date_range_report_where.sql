        (
          report_cat_date_ranges.start_date between '2013-09-01' and '2013-09-18'
          or
          '2013-09-01' between report_cat_date_ranges.start_date and report_cat_date_ranges.stop_date
        )
 and report_cat_date_ranges.period = 'weekly'