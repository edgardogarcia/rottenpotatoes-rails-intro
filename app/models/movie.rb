class Movie < ActiveRecord::Base
    
    def ratings_all
        return ['G','PG','PG-13','R']
    end
end
