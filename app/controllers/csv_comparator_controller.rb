# frozen_string_literal: true

class CsvComparatorController < ApplicationController
  def create
    comparator = CsvComparator.new([comparator_params[:key_one], comparator_params[:key_two]])
    @results = comparator.compare!

    respond_to do |format|
      format.json { render json: @results, status: :ok }
      format.js
    end
  end

  private

  def comparator_params
    params.require(:comparator).permit(%i[key_one key_two])
  end
end
