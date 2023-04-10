# frozen_string_literal: true

module RuboCop
  module Cop
    module InternalAffairs
      # Checks for redundant message arguments to `#add_offense`. This method
      # will automatically use `#message` or `MSG` (in that order of priority)
      # if they are defined.
      #
      # @example
      #
      #   # bad
      #   add_offense(node, message: MSG)
      #   add_offense(node, message: message)
      #   add_offense(node, message: message(node))
      #
      #   # good
      #   add_offense(node)
      #   add_offense(node, message: CUSTOM_MSG)
      #   add_offense(node, message: message(other_node))
      #
      class RedundantMessageArgument < Cop
        include RangeHelp

        MSG = 'Redundant message argument to `#add_offense`.'

        def_node_matcher :node_type_check, <<~PATTERN
          (send nil? :add_offense $_node $hash)
        PATTERN

        def_node_matcher :redundant_message_argument, <<~PATTERN
          (pair
            (sym :message)
            ${(const nil? :MSG) (send nil? :message) (send nil? :message _)})
        PATTERN

        def_node_matcher :message_method_call, '(send nil? :message $_node)'

        def on_send(node)
          node_type_check(node) do |node_arg, kwargs|
            find_offending_argument(node_arg, kwargs) do |pair|
              add_offense(pair)
            end
          end
        end

        def autocorrect(node)
          range = offending_range(node)

          ->(corrector) { corrector.remove(range) }
        end

        private

        def offending_range(node)
          with_space = range_with_surrounding_space(range: node.loc.expression)

          range_with_surrounding_comma(with_space, :left)
        end

        def find_offending_argument(searched_node, kwargs)
          kwargs.pairs.each do |pair|
            redundant_message_argument(pair) do |message_argument|
              node = message_method_call(message_argument)

              yield pair if !node || node == searched_node
            end
          end
        end
      end
    end
  end
end
