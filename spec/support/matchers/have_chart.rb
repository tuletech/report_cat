RSpec::Matchers.define :have_chart do |name|
  chain :with_type do |type|
    @type = type
  end

  match do |report|
    chart = report.charts.select{ |chart| chart.name == name }.first

    @has_chart = !chart.nil?

    if @type
      @has_chart && chart.type == @type
    else
      @has_chart
    end
  end
end