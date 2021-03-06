require 'cucumber/core/ast/location'
require 'cucumber/core/ast/describes_itself'
require 'cucumber/core/ast/step'

module Cucumber
  module Core
    module Ast

      class OutlineStep
        include HasLocation
        include DescribesItself

        attr_reader :language, :location, :keyword, :name, :multiline_arg

        def initialize(language, location, keyword, name, multiline_arg)
          @language, @location, @keyword, @name, @multiline_arg = language, location, keyword, name, multiline_arg
          @language || raise("Language is required!")
          @gherkin_statement = nil
        end

        def gherkin_statement(node = nil)
          @gherkin_statement ||= node
        end

        def to_step(row)
          step = Ast::Step.new(language, location, keyword, row.expand(name), replace_multiline_arg(row))
          step.gherkin_statement(@gherkin_statement)
          step
        end

        private

        def description_for_visitors
          :outline_step
        end

        def children
          # TODO remove duplication with Step
          # TODO spec
          [@multiline_arg]
        end

        def replace_multiline_arg(example_row)
          return unless multiline_arg
          multiline_arg.map { |cell| example_row.expand(cell) }
        end
      end

    end
  end
end

