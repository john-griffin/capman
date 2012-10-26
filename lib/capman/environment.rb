module Capman
  class Environment
    attr_reader :variables

    def initialize(variables = {})
      @variables = variables
    end

    def get(name)
      variables[name]
    end

    def set(name, value)
      if value.nil? || value.empty?
        variables.delete(name)
      else
        @variables[name] = value
      end
    end

    def set_string(string)
      if string =~ /\A([A-Za-z0-9_]+)=(.*)\z/
        set $1, $2
      end
    end

    def empty?
      variables.empty?
    end

    def each(&block)
      variables.sort.each(&block)
    end

    def to_s
      variables.keys.sort.map do |key|
        key + "=" + variables[key] + "\n" if variables[key]
      end.compact.join
    end

    def self.from_string(string)
      string.split(/[\n\r]/).inject(new) do |env, line|
        env.set_string(line)
        env
      end
    end
  end
end