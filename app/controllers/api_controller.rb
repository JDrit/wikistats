require "json"
require "base64"
require "open-uri"

class ApiController < ApplicationController
    def get_index
        result = []

        begin
            options = { :headers => 
                        { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}, 
                        :timeout => 10 }
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
        page_title = Rack::Utils.escape(params[:page_title])
        result = []
        Rails.logger.info Rack::Utils.escape(page_title)
        begin
            options = { :headers => 
                        { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}, 
                        :timeout => 10}
            response = HTTParty.get(
                "http://namenode.csh.rit.edu:20550/pages/#{page_title}/test", options)

            data = JSON.parse(response.body)
            data['Row'][0]['Cell'].each do |cell|
                cell = Base64.decode64(cell['$'])
                cell.split(",").each do |elem|
                  split = elem.split("-")
                  result << [split[0].to_i * 1000, split[1].to_i]
                end
            end

           response = HTTParty.get(
                "http://namenode.csh.rit.edu:20550/pages/#{page_title}/timestamps", options)

            data = JSON.parse(response.body)
            data['Row'][0]['Cell'].each do |cell|
                timestamp = Base64.decode64(cell['column']).split(":")[1].to_i * 1000
                count = Base64.decode64(cell['$']).to_i
                result << [timestamp, count]
            end
            result = result.sort_by{ |e| e[0] }
        rescue Net::ReadTimeout
            Rails.logger.error "HTTP timeout to hbase fetching #{page_title}"
        end
        render json: result.to_json, :callback => params['callback']

    end
end
