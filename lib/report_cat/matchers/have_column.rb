RSpec::Matchers.define :have_column do |name|

  description do
    "have a column named #{name}"
  end

  chain :with_type do |type|
    @type = type
  end

  chain :with_options do |options|
    @options = options
  end

  match do |report|
    column = report.columns.select{ |column| column.name == name }.first

    @has_column = !column.nil?
    @has_column = ( column.type == @type ) if @type && @has_column
    @has_column = ( column.options == @options ) if @options && @has_column

    @has_column
  end

  failure_message_for_should do |report|
    message = "expected that report would have a column named #{name}"

    column = report.columns.select{ |column| column.name == name }.first
    message << " with type #{@type} but got #{column.type}" if column && column.type != @type
    message << " with options #{@options} but got #{column.options}" if column && column.options != @options

    message
  end

  failure_message_for_should_not do |report|
    message = "expected that report would not have a column named #{name}"

    column = report.columns.select{ |column| column.name == name }.first
    message << " with type #{@type} but got #{column.type}" if column && column.type != @type
    message << " with options #{@options} but got #{column.options}" if column && column.options != @options

    message
  end

end