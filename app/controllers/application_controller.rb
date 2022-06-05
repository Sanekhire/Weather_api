class ApplicationController < ActionController::Base

    def not_found
        render :file => "#{Rails.root}/public/404.html",  :status => 404
    end

    def health
        render plain: "OK", :status => 200
        

    end

end
