require 'securerandom'

class ShortenedUrl < ApplicationRecord
    validates :short_url, presence: true, uniqueness: true
    validates :long_url, presence: true
    validates :user_id, presence: true

  belongs_to :submitter,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id
    
	has_many :visits,
		class_name: :Visit,
    foreign_key: :shortenedurl_id,
    primary_key: :id

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :users_visited

  def self.converter(user, long_url)
    thing = ShortenedUrl.new(user_id: user.id, long_url: long_url, short_url: ShortenedUrl.random_code)
    thing.save!
  end

  def self.random_code
    short = SecureRandom.urlsafe_base64(16)

    until !ShortenedUrl.exists?(:short_url => short)
      short = SecureRandom.urlsafe_base64(16)
    end

    short
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    visitors.where("visits.created_at > ?", 60.minutes.ago).count
  end


end

