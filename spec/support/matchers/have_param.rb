RSpec::Matchers.define :have_param do |name|
  chain :with_type do |type|
    @type = type
  end

  match do |report|
    param = report.params.select{ |param| param.name == name }.first

    @has_param = !param.nil?

    if @type
      @has_param && param.type == @type
    else
      @has_param
    end
  end
end