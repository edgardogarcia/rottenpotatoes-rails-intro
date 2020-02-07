class Movie < ActiveRecord::Base
    
    def self.ratings_all
        return ['G','PG','PG-13','R']
    end
end
