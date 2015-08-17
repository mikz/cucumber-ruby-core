require 'gherkin3/parser'
require 'gherkin3/token_scanner'
require 'gherkin3/errors'
require 'cucumber/core/gherkin/ast_builder'
require 'cucumber/core/ast'

module Cucumber
  module Core
    module Gherkin
      ParseError = Class.new(StandardError)

      class Parser
        attr_reader :receiver
        private     :receiver

        def initialize(receiver)
          @receiver = receiver
        end

        def document(document)
          parser  = ::Gherkin3::Parser.new
          scanner = ::Gherkin3::TokenScanner.new(document.body)
          core_builder = AstBuilder.new(document.uri)

          if document.body.strip.empty?
            return receiver.feature Ast::NullFeature.new
          end

          begin
            result = parser.parse(scanner)

            receiver.feature core_builder.feature(result)
          rescue *PARSER_ERRORS => e
            raise Core::Gherkin::ParseError.new("#{document.uri}: #{e.message}")
          end
        end

        def done
          receiver.done
          self
        end

        private

        PARSER_ERRORS = ::Gherkin3::ParserError

      end
    end
  end
end
