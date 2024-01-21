class User < ApplicationRecord
    before_create :generate_random_id

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true

    has_many :posts
    has_many :comments

    private

    def generate_random_id
        self.id = SecureRandom.uuid
    end
end
