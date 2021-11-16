# frozen_string_literal: true

class ReportsController < ApplicationController
  def matches
    @results = Set.new
    reference = Rails.cache.read(params[:ref][0])

    reference[:unmatched].each do |value|
      distance = params[:row].length - (params[:row] & value).length
      @results.add(value) if distance <= 2
    end

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
