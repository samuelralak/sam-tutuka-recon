# frozen_string_literal: true

class ReportsController < ApplicationController
  def create
    @results = Rails.cache.read_multi(report_params[:key_one], report_params[:key_two])

    respond_to do |format|
      format.json { render json: @results, status: :ok }
      format.js
    end
  end

  private

  def report_params
    params.require(:report).permit(%i[key_one key_two])
  end
end
