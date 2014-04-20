RSpec::Matchers.define :have_column do |name|
  chain :with_type do |type|
    @type = type
  end

  match do |report|
    column = report.columns.select{ |column| column.name == name }.first

    @has_column = !column.nil?

    if @type
      @has_column && column.type == @type
    else
      @has_column
    end
  end
end