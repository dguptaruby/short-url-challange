class ShortUrl < ApplicationRecord

   scope :latest, -> { limit(100).order(created_at::desc) }

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  def short_code
    "g9"
  end

  def self.shorten(url, title = '')
    short_url = ShortUrl.where(url: full_url, title: title).first
    return short_url.short if short_url 
      
    short_url = ShortUrl.new(url: full_url, title: title)
    return short_url.short if short_url.save

    ShortUrl.shorten(full_url, title + SecureRandom.uuid[0..2])
  end

  def update_title
    UpdateTitleJob.perform_now(id)
  end

  private

  def validate_full_url
    true
  end

end
