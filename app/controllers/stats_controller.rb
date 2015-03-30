require "json"
require "base64"
require "nokogiri"
require "open-uri"
require "httpclient"

class StatsController < ApplicationController
    def index
        if params[:page_titles].nil? then
            @page_titles = ["Google", "Facebook", "Apple_Inc.", "Twitter", "Microsoft"]
        else
            @page_titles = params[:page_titles].split(",").map { |title| get_page_info(title)[0] }
        end

    end

    def show_pages
        page_titles = ""
        params[:page_titles].each do |title|
            page_titles += title + ","
        end
        redirect_to action: "index", page_titles: page_titles
    end

    def show
        @page_title_url = Rack::Utils.escape(params[:page_title])
        @page_title = params[:page_title]
        @page_views = 0

        true_title, @image_url = get_page_info @page_title
        if true_title != @page_title then
            redirect_to action: "show", page_title: true_title
        end
    end

    private
    # returns a tuple of the true title of the page and an image url, if there is one
    def get_page_info page_title
        begin
            page = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{page_title}"))
            title = page.css("#firstHeading").text.tr(" ", "_")
            logos = page.css("a.image img")
            if logos.length > 0 then
                return title, "http:" + logos[0]['src']
            else
                return title, ""
            end

        rescue Exception => e
            Rails.logger.error "Error getting page info for #{page_title} : #{e}"
            return @page_title, ""
        end
    end
end
