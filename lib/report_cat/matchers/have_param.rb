RSpec::Matchers.define :have_param do |name|

  description do
    "have a param named #{name}"
  end

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

  failure_message do |report|
    message = "expected that report would have a param named #{name}"

    param = report.params.select{ |param| param.name == name }.first
    message << " with type #{@type} but got #{param.type}" if param && param.type != @type
    message << " with value #{@value} but got #{param.value}" if param && param.value != @value
    message << " with options #{@options} but got #{param.options}" if param && param.options != @options

    message
  end

  failure_message_when_negated do |report|
    message = "expected that report would not have a param named #{name}"

    param = report.params.select{ |param| param.name == name }.first
    message << " with type #{@type} but got #{param.type}" if param && param.type != @type
    message << " with value #{@value} but got #{param.value}" if param && param.value != @value
    message << " with options #{@options} but got #{param.options}" if param && param.options != @options

    message
  end

end