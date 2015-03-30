require "json"
require "base64"

class ApiController < ApplicationController
    def get_index
        result = []
        
        begin
            options = { :headers => 
                        { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}, 
                        :timeout => 2 }
            response = HTTParty.get(
                "http://namenode.csh.rit.edu:20550/overview/pageviews/timestamps", options)
            
            data = JSON.parse(response.body)

            data['Row'][0]['Cell'].each do |cell|
                timestamp = Base64.decode64(cell['column']).split(":")[1].to_i * 1000
                count = Base64.decode64(cell['$']).to_i
                result << [timestamp, count]
            end

        rescue Net::ReadTimeout
            Rails.logger.error "HTTP timeout to hbase fetching #{page_title}"
        end
        render json: result.to_json, :callback => params['callback']
    end
    
    def get_page
        page_title = params[:page_title]
        result = []

        begin
            options = { :headers => 
                        { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}, 
                        :timeout => 7}
            response = HTTParty.get(
                "http://namenode.csh.rit.edu:20550/pages/#{page_title}/timestamps", options)
            
            data = JSON.parse(response.body)

            data['Row'][0]['Cell'].each do |cell|
                timestamp = Base64.decode64(cell['column']).split(":")[1].to_i * 1000
                count = Base64.decode64(cell['$']).to_i
                result << [timestamp, count]
            end

        rescue Net::ReadTimeout
            Rails.logger.error "HTTP timeout to hbase fetching #{page_title}"
        end
        render json: result.to_json, :callback => params['callback']
        

    end
end
