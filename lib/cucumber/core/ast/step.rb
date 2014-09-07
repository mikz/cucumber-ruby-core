require 'cucumber/core/ast/describes_itself'
require 'cucumber/core/ast/location'

module Cucumber
  module Core
    module Ast
      class Step #:nodoc:
        include HasLocation
        include DescribesItself

        attr_reader :keyword, :name, :language, :exception, :multiline_arg, :gherkin_statement

        def initialize(gherkin_statement, language, location, keyword, name, multiline_arg)
          @gherkin_statement, @location, @keyword, @name, @multiline_arg = gherkin_statement, location, keyword, name, multiline_arg
        end

        def to_sexp
          [:step, line, keyword, name, @multiline_arg.to_sexp]
        end

        private

        def children
          [@multiline_arg]
        end

        def description_for_visitors
          :step
        end
      end

      class ExpandedOutlineStep < Step #:nodoc:

        def initialize(outline_step, gherkin_statement, language, location, keyword, name, multiline_arg)
          @outline_step, @gherkin_statement, @location, @keyword, @name, @multiline_arg = outline_step, gherkin_statement, location, keyword, name, multiline_arg
        end

        alias :self_match_locations? :match_locations?

        def match_locations?(queried_locations)
          self_match_locations?(queried_locations) or @outline_step.match_locations?(queried_locations)
        end
      end
    end
  end
end
