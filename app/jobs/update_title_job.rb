class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    short_url = ShortUrl.find(short_url_id)
    full_url = short_url.full_url
    response = Net::HTTP.get_response(URI.parse(full_url))
    short_url.update_attribute(:title, response.body[/#{'<title>'}(.*?)#{'</title>'}/m, 1] )
  end
end
