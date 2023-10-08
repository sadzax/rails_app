class Vm < ApplicationRecord
    has_and_belongs_to_many :project
    has_many :hdd
end
