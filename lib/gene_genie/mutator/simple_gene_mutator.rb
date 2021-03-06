module GeneGenie
  # A SimpleGeneMutator loops through each member of a hash, and has a 1%
  # chance of swapping the value for another valid value (based on the
  # template)
  # @since 0.0.1
  class SimpleGeneMutator
    def initialize(template, mutation_rate = 0.01)
      @template = template
      @mutation_rate = mutation_rate
    end

    def call(hash)
      hash.each do |k, v|
        if rand < @mutation_rate
          hash[k] = rand(@template[k])
        end
      end
      hash
    end
  end
end

