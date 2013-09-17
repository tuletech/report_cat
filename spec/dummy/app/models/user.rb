class User < ActiveRecord::Base

  def self.random( total,  days )
    User.record_timestamps = false

    (1..total).each do |i|
      User.create( :created_at => Time.now - rand( days ).days )
    end

    User.record_timestamps = true
  end

end