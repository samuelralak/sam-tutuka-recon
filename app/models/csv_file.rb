# frozen_string_literal: true

require 'csv'

class CsvFile
  include ActiveModel::Validations

  def initialize(attachment)
    @attachment = attachment
  end

  def load!
    return write_to_cache if @attachment.respond_to?(:content_type) && @attachment.content_type.eql?('text/csv')

    errors.add :format, 'must be of type text/csv'
    raise ActiveRecord::RecordInvalid, self
  end

  def meta
    @meta ||= Hash[
      cache_key: cache_key,
      filename: @attachment&.original_filename,
      rows: Set.new,
      duplicates: Set.new,
      count: 0,
      matched: 0,
      unmatched: Set.new,
      headers: []
    ]
  end

  private

  def cache_key
    "#{Time.now.to_i}_#{@attachment.original_filename}"
  end

  def write_to_cache
    CSV.foreach(@attachment).with_index do |row, index|
      if index.eql?(0)
        meta[:headers] = row
        next
      end

      update_rows(row)
      meta[:count] = meta[:count] + 1
    end

    Rails.cache.fetch(meta[:cache_key]) { meta }
    self
  end

  def update_rows(row)
    meta[:duplicates].add(row) if meta[:rows].include?(row)
    meta[:rows].add(row)
  end
end
