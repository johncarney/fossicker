require "fossicker/version"

module Fossicker
  def self.fossick(object, *keys, **options, &block)
    default = options.key?(:default) ? [ options[:default] ] : []
    keys.reduce(object) do |result, key|
      # We're taking advantage fof the fact that returning from a bloc exits the enclosing method. We invoke fetch
      # again to ensure we behave the same way with respect to defaults that Array#fetch and Hash#fetch do.
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
