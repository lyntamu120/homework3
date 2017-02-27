class Movie < ActiveRecord::Base
  def self.all_ratings
    {"PG" => "1", "PG-13"=>"1", "G" => 1, "R" => 1, "NC-17" => 1}
  end
end
