require "brainfuckrb/version"
require "io/console"

module Brainfuckrb

  class Brainfuck
    def initialize(program)
      @program = program
      reset
    end

    def reset
      @mem = [0] * 65535
      @p = 0
      @pc = 0
      @out = ''
    end

    def run(stop = nil)
      reset
      _run(stop)
      result = @mem[@p]
      @out
    end

    def _run(stop = nil)
      stop ||= @program.length

      while @pc < stop
        case @program[@pc].chr
          when ">" then @p += 1
          when "<" then @p -= 1
          when "+" then @mem[@p] += 1
          when "-" then @mem[@p] -= 1
          when "." then @out << @mem[@p].chr
          when "," then @mem[@p] = STDIN.readchar.ord
          when "["
            depth = 1
            start = _end = @pc
            while depth != 0
                _end += 1
                depth += 1 if @program[_end] == "["
                depth -= 1 if @program[_end] == "]"
            end
            while @mem[@p] != 0
                @pc = start + 1 
                _run(_end)
            end
            @pc = _end
          when "]" then raise "x:y: not expecting \']\'" 
        end
        @pc += 1
      end
    end

  end
end
