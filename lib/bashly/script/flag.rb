require 'shellwords'

module Bashly
  module Script
    class Flag < Base
      include Completions::Flag
      include Introspection::Visibility
      include Introspection::Validate

      class << self
        def option_keys
          @option_keys ||= %i[
            alias allowed arg completions conflicts default help long needs
            private repeatable required short unique validate
          ]
        end
      end

      def alt
        return [] unless options['alias']

        options['alias'].is_a?(String) ? [options['alias']] : options['alias']
      end

      def aliases
        primary_aliases + alt
      end

      def default_string
        if default.is_a?(Array)
          Shellwords.shelljoin default
        elsif default.is_a?(String) && repeatable
          Shellwords.shellescape default
        else
          default
        end
      end

      def name
        long || short
      end

      def usage_string(extended: false)
        result = [aliases.join(', ')]
        result << arg.upcase if arg
        result << strings[:required] if required && extended
        result << strings[:repeatable] if repeatable && extended
        result.join ' '
      end

    private

      def primary_aliases
        [long, short].compact
      end
    end
  end
end
