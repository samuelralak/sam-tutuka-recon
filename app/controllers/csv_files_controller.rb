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

# def create
#   @random_modal = RandomModal.new(random_modal_params)
#
#   respond_to do |format|
#     if @random_modal.save
#       format.html { redirect_to @random_modal, notice: "Random modal was successfully created." }
#       format.json { render :show, status: :created, location: @random_modal }
#     else
#       format.html { render :new, status: :unprocessable_entity }
#       format.json { render json: @random_modal.errors, status: :unprocessable_entity }
#     end
#   end
# end
