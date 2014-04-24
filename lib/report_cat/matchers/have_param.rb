RSpec::Matchers.define :have_param do |name|
  chain :with_type do |type|
    @type = type
  end

  chain :with_value do |value|
    @value = value
  end

  chain :with_options do |options|
    @options = options
  end

  match do |report|
    param = report.params.select{ |param| param.name == name }.first

    @has_param = !param.nil?
    @has_param = ( param.type == @type ) if @type && @has_param
    @has_param = ( param.value == @value ) if @value && @has_param
    @has_param = ( param.options == @options ) if @options && @has_param

    @has_param
  end
end