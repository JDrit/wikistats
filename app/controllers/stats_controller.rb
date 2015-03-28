class StatsController < ApplicationController
    def index
        @page_title = 'Main_Page'
    end

    def show
        @page_title = params[:page_title]
    end
end
