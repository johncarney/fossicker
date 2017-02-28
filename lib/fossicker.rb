require "fossicker/version"

module Fossicker
  def self.fossick(object, *keys, **options, &block)
    default = options.key?(:default) ? [ options[:default] ] : []
    keys.reduce(object) do |result, key|
      result.fetch(key) { return result.fetch(key, *default, &block) }
    end
  end

  def fossick(*keys, **options, &block)
    Fossicker.fossick(self, *keys, **options, &block)
  end

  refine Hash do
    include Fossicker
  end

  refine Array do
    include Fossicker
  end
end
