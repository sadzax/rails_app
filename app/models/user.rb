class User < ApplicationRecord
    scope :longname, -> { where('length(first_name) > 5') }
    has_many :orders  
    has_one :passport_data
end