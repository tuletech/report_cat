module ReportCat
  module ReportsHelper

    def report_param( param )
      case param.type
        when :check_box  then return check_box_tag( param.name, '1', param.value )
        when :date       then return select_date( param.value, :prefix => param.name )
        when :hidden     then return hidden_field_tag( param.name, param.value ) + param.value.to_s
        when :select     then return select_tag( param.name, options_for_select( param.options, param.value ) )
        when :text_field then return text_field_tag( param.name, param.value )
        else
          raise "Unknown param: #{param.type}"
      end
    end

  end
end
