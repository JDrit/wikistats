class StatsController < ApplicationController
    def index
        @page_title = 'Main_Page'
    end

    def show
        @page_title = params[:page_title]
        @page_views = 0

        begin
            options = { :headers => 
                        { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}, 
                        :timeout => 2}
            response = HTTParty.get(
                "http://namenode.csh.rit.edu:20550/pages/#{page_title}/overview", options)
            
            data = JSON.parse(response.body)
            overview_data = {}

            data['Row'][0]['Cell'].each do |cell|
                column = Base64.decode64(cell['column']).split(":")[1]
                value = Base64.decode64(cell['$'])
                overview_data[column] = value
            end
            @page_views = overview_data["total_views"]

        rescue Net::ReadTimeout
            Rails.logger.error "HTTP timeout to hbase fetching #{page_title}"
        end

    end
end
