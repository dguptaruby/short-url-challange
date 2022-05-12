class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(click_count: :desc).limit(100)
    if @short_urls 
      head :ok 
    else
      head :no_content
    end
  end

  def show
    @short_urls = ShortUrl.first 
    @short_urls.update_attribute(:click_count, @short_urls.click_count + 1)
    redirect_to @short_urls.full_url
  end

  def new
    @short_urls = ShortUrl.new
  end

  def create
    @short_urls = ShortUrl.new(full_url: params[:full_url])
    
    respond_to do |format|
      if @short_urls.save
        format.html { redirect_to @short_urls.full_url, notice: 'Short url was successfully created.' }
        format.js
        format.json { render action: 'show', status: :created, location: @short_urls }
      else
        format.html { render action: 'new' }
        format.json { render json: @short_urls.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def short_url_params
    params.require(:short_urls).permit(:full_url)
  end

end
