class Order < ApplicationRecord
    scope :high_cost, -> { where(cost: 1_000..) }
    scope :vip_failed, -> { failed.high_cost }
    scope :created_before, -> (time) { where('created_at < ?', time)}
    enum status: {unavailable: 0, created: 1, started: 2, failed: 3, removed: 4}
    belongs_to :user
    has_and_belongs_to_many :tags
    has_and_belongs_to_many :networks
end
