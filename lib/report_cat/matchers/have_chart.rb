RSpec::Matchers.define :have_chart do |name|
  chain :with_type do |type|
    @type = type
  end

  chain :with_label do |label|
    @label = label
  end

  chain :with_values do |values|
    @values = values
  end

  chain :with_options do |options|
    @options = options
  end

  match do |report|
    chart = report.charts.select{ |chart| chart.name == name }.first

    @has_chart = !chart.nil?
    @has_chart = ( chart.type == @type ) if @type && @has_chart
    @has_chart = ( chart.label == @label ) if @label && @has_chart
    @has_chart = ( chart.values == @values ) if @values && @has_chart
    @has_chart = ( chart.options == @options ) if @options && @has_chart

    @has_chart
  end
end