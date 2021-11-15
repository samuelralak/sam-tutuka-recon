# frozen_string_literal: true

class CsvComparator
  include ActiveModel::Validations

  def initialize(keys = [])
    @keys = keys
  end

  def compare!
    caches = Rails.cache.read_multi(@keys.first, @keys.second)
    result = fetch_unmatched(caches)
    update_and_read(result)
  end

  private

  def update_and_read(value)
    keys = value.keys
    Rails.cache.write_multi(value)
    Rails.cache.read_multi(keys.first, keys.second)
  end

  def fetch_unmatched(caches)
    cache_one = caches.fetch(@keys.first)
    cache_two = caches.fetch(@keys.second)

    Hash[
      cache_one[:cache_key] =>
        cache_one.merge(unmatched(cache_one[:rows], cache_two[:rows])),

      cache_two[:cache_key] =>
        cache_two.merge(unmatched(cache_two[:rows], cache_one[:rows]))
    ]
  end

  def unmatched(rows, reference)
    unmatched = Set.new
    rows.each { |row| unmatched.add(row) unless reference.include?(row) }
    Hash[unmatched: unmatched, matched: rows.size - unmatched.size]
  end
end
