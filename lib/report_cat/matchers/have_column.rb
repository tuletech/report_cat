RSpec::Matchers.define :have_column do |name|
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
end