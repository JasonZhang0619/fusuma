require_relative '../base.rb'

module Fusuma
  module Plugin
    # vector class
    module Vectors
      # Inherite this base
      class Vector < Base
        def initialize
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        def direction
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        def enough?
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        def index
          raise NotImplementedError, "override #{self.class.name}##{__method__}"
        end

        class << self
          # @param event_buffer [EventBuffer]
          # @return [Vector]
          def generate(event_buffer:); end

          def touch_last_time
            @last_time = Time.now
          end
        end
      end

      # Generate vector
      class Generator
        class << self
          attr_writer :prev_vector
          attr_reader :prev_vector
        end

        # @param event_buffer [EventBuffer]
        def initialize(event_buffer:)
          @event_buffer = event_buffer
        end

        # Generate vector
        # @return [vector]
        def generate
          plugins.map do |klass|
            klass.generate(event_buffer: @event_buffer)
          end.compact.first
        end

        # vector plugins
        # @example
        #  [Vectors::RotateVector, Vectors::PinchVector,
        #   Vectors::SwipeVector]
        # @return [Array]
        def plugins
          # NOTE: select vectors only defined in config.yml
          Vector.plugins.select do |klass|
            index = Config::Index.new(klass::TYPE)
            Config.search(index)
          end
        end
      end
    end
  end
end