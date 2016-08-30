require 'pathname'

module BrewCaskTools
  ##
  # Shared helper methods
  ##
  module Util
    GEM_PATH = Pathname.new(__FILE__).join('../../..').expand_path

    class << self
      ##
      # Transform helpers
      ##
      def to_array(arg)
        arg.is_a?(Array) ? arg : [arg]
      end

      ##
      # Relative path from working directory
      ##
      def relative_path(*relative)
        Pathname.pwd.join(*relative.flatten.map(&:to_s)).expand_path
      end

      def source_path(*relative)
        GEM_PATH.join(*relative.flatten.map(&:to_s)).expand_path
      end
    end
  end
end
