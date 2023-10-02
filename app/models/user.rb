class User < ApplicationRecord
    has_many :orders  # руками прописал
    has_one :passport_data  # руками прописал
end