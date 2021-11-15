# frozen_string_literal: true

class CsvComparator
  def initialize(keys = [])
    @keys = keys
  end

  def compare!
    caches = Rails.cache.read_multi(@keys.first, @keys.second)
    result = result_from_cache(caches)

    Rails.cache.write(@keys.first, result.fetch(@keys&.first))
    Rails.cache.write(@keys.second, result.fetch(@keys.second))

    {
      @keys.first =>
        Rails.cache.fetch(@keys.first, force: true) do
          result.fetch(@keys&.first)
        end,

      @keys.second =>
        Rails.cache.fetch(@keys.second, force: true) do
          result.fetch(@keys.second)
        end
    }
  end

  private

  def result_from_cache(caches)
    cache_one = caches.fetch(@keys.first)
    cache_two = caches.fetch(@keys.second)

    {
      cache_one[:cache_key] =>
        cache_one
          .merge(unmatched(cache_one[:rows], cache_two[:rows])),

      cache_two[:cache_key] =>
        cache_two
          .merge(unmatched(cache_two[:rows], cache_one[:rows]))
    }
  end

  def unmatched(rows, reference)
    unmatched = Set.new
    rows.each { |row| unmatched.add(row) unless reference.include?(row) }
    Hash[unmatched: unmatched, matched: rows.size - unmatched.size]
  end
end
