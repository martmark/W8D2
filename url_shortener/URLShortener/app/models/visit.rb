class Visit < ApplicationRecord
    validates :user_id, presence: true
    validates :shortenedurl_id, presence: true

    belongs_to :users_visited,
        class_name: :User,
        primary_key: :id,
        foreign_key: :user_id
    
    belongs_to :urls_visited,
        class_name: :ShortenedUrl,
        primary_key: :id,
        foreign_key: :shortenedurl_id

    def self.record_visit!(user, shortened_url)
        thing = Visit.new(user_id: user.id, shortenedurl_id: shortened_url.id)
        thing.save!
    end
end