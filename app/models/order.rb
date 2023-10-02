class Order < ApplicationRecord
    belongs_to :user  # руками прописал
    has_and_belongs_to_many :tags  # руками прописал
end
