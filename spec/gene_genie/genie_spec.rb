require 'minitest_helper'
require 'gene_genie'

# The basic Genie class. For the simplest optimisation, with best-guess
# optimisations, this is all you need.
# See template_spec and fitness_evaluator_spec descriptions of the parameters
module GeneGenie
  describe Genie do

    let(:genie) { Genie.new(sample_template, sample_fitness_evaluator) }
    describe '#initialize' do
      it 'is initialised with a template and a fitness evaluator' do
        assert_kind_of Genie, genie
      end
    end

    describe '#optimise' do
      it 'returns true when it improves current best_fitness' do
        changing_fitness_evaluator = TailoredFitnessEvaluator.new(1)

        genie = Genie.new(sample_template, changing_fitness_evaluator)
        first_fitness = genie.best_fitness
        changing_fitness_evaluator.set_fitness(2)

        assert_equal true, genie.optimise(1)
      end

      it "returns false when it doesn't improve current best_fitness" do
        unchanging_fitness_evaluator = TailoredFitnessEvaluator.new(1)

        genie = Genie.new(sample_template, unchanging_fitness_evaluator)
        first_fitness = genie.best_fitness

        assert_equal false, genie.optimise(1)
      end

      it 'takes an optional number_of_generations argument' do
        genie.optimise(10)
        # evolve should be called on genepool 10 times
      end

      it 'optimises' do
        assert_equal true, genie.optimise(2000), "didn't improve"
        assert_equal true, genie.best_fitness > (90 * 90),
          "didn't find a good result"
      end

      it 'also optimizes' do
        assert_equal true, genie.respond_to?(:optimize), 'optimize variant not recognised'
      end
    end

    describe '#best' do
      it 'returns a Hash, conforming to the supplied template' do
        optimised = genie.best
        assert_kind_of Hash, optimised
        sample_template.each do |k, v|
          refute_nil optimised[k]
          assert_equal true, optimised[k] >= v.min
          assert_equal true, optimised[k] <= v.max
        end
      end

      it 'returns optimised data' do
        initial_best = genie.best
        initial_best_fitness = sample_fitness_evaluator.fitness(initial_best)

        genie.optimise

        optimised_many = genie.best
        optimised_many_fitness = sample_fitness_evaluator.fitness(optimised_many)

        assert_equal true, initial_best_fitness < optimised_many_fitness,
          'fitness did not improve'
        # this test might not always pass. #statistics
      end
    end

    describe '#best_fitness' do
      it 'returns the fitness of the best gene' do
        genie.optimise(1)
        optimised = genie.best
        optimised_fitness = sample_fitness_evaluator.fitness(optimised)
        assert_equal true, optimised_fitness == genie.best_fitness
      end
    end
  end
end
