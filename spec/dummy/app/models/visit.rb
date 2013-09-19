class Visit < ActiveRecord::Base

  def self.random( number, delay )

    User.find_each do |user|
      created_at = user.created_at
      (1..number).each do |i|
        Visit.create( :user_id => user.id, :created_at => created_at )
        created_at += rand( delay ).days
      end
    end

  end


end
