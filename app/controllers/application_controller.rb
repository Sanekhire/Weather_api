# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def health
    render plain: 'OK', status: :ok
  end
end
