RSpec::Matchers.define :have_chart do |name|

  description do
    "have a chart named #{name}"
  end

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

  failure_message_for_should do |report|
    message = "expected that report would have a chart named #{name}"

    chart = report.charts.select{ |chart| chart.name == name }.first
    message << " with type #{@type} but got #{chart.type}" if chart && chart.type != @type
    message << " with label #{@label} but got #{chart.label}" if chart && chart.label != @value
    message << " with options #{@values} but got #{chart.values}" if chart && chart.values != @values
    message << " with options #{@options} but got #{chart.options}" if chart && chart.options != @options

    message
  end

  failure_message_for_should_not do |report|
    message = "expected that report would not chart a param named #{name}"

    chart = report.charts.select{ |chart| chart.name == name }.first
    message << " with type #{@type} but got #{chart.type}" if chart && chart.type != @type
    message << " with label #{@label} but got #{chart.label}" if chart && chart.label != @value
    message << " with options #{@values} but got #{chart.values}" if chart && chart.values != @values
    message << " with options #{@options} but got #{chart.options}" if chart && chart.options != @options

    message
  end
end