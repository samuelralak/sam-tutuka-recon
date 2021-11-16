# frozen_string_literal: true

class CsvFilesController < ApplicationController
  def create
    file = CsvFile.new(csv_file_params[:attachment])
    file.load!

    render json: file.meta[:cache_key], status: :ok
  end

  private

  def csv_file_params
    params.require(:csv_file).permit(:attachment)
  end
end
