require 'securerandom'

class User < ApplicationRecord
    before_create :generate_random_id

    validates :username, presence: true, uniqueness: true, format: { without: /\s/, message: "cannot contain spaces" }
    validates :email, presence: true, uniqueness: true

    has_many :posts
    has_many :comments

    self.primary_key = 'id'

    private

    def generate_random_id
        self.id = SecureRandom.uuid_v4
    end
end
