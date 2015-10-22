require 'pathname'

module HtmlProcessor
  module Step
    class << self
      def to_step(argument)
        return argument if argument.respond_to?(:call)
        registered = registered_steps.find { |step| step.step_name.to_s == argument.to_s } if argument.respond_to?(:to_s)
        registered || raise("Unable to interpret #{argument.inspect} as processing step")
      end

      private

      attr_reader :registered_steps

      def load_and_register_steps
        myself = Pathname(__FILE__)
        steps_dir = myself.dirname.join(myself.basename('.rb'))
        steps_dir.children.each do |path|
          basename = path.basename('.rb')
          require "html_processor/step/#{basename}"

          constant_name = basename
            .to_s
            .split('_')
            .map { |segment| "#{segment[0].upcase}#{segment[1..-1]}" }
            .join('')
          registered_steps << const_get(constant_name)
        end
      end
    end

    @registered_steps = []
    load_and_register_steps
  end
end

