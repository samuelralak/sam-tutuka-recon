# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvComparator do
  describe 'File Reconciliation' do
    before do
      Rails.cache.clear
      ActionController::Base.perform_caching = true
    end

    after do
      ActionController::Base.perform_caching = false
    end

    let(:file_a) { File.new(Rails.root.join('spec/fixtures/files/file_a.csv')) }
    let(:file_b) { File.new(Rails.root.join('spec/fixtures/files/file_b.csv')) }

    let(:attachment_a) do
      ActionDispatch::Http::UploadedFile.new(tempfile: file_a,
                                             filename: File.basename(file_a),
                                             type: 'text/csv')
    end

    let(:attachment_b) do
      ActionDispatch::Http::UploadedFile.new(tempfile: file_b,
                                             filename: File.basename(file_b),
                                             type: 'text/csv')
    end

    it 'reconciles file_a and file_b' do
      result_a = CsvFile.new(attachment_a).load!
      result_b = CsvFile.new(attachment_b).load!
      comparison = described_class.new([result_a.meta[:cache_key], result_b.meta[:cache_key]]).compare!
      expect(comparison.keys).to eq [result_a.meta[:cache_key], result_b.meta[:cache_key]]
    end
  end
end
