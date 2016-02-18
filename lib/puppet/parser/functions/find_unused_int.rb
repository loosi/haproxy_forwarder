module Puppet::Parser::Functions
  newfunction(:find_unused_int, :type => :rvalue) do |args|
    if args.size != 1 then
      raise(Puppet::ParseError, "find_unused_int(): wrong number of arguments")
    end
    unless args[0].is_a?(Array)
      raise(Puppet::ParseError, 'basename(): Requires Array as first argument')
    end
    used = args[0].map(&:to_i)
    1.upto(Float::INFINITY).detect { |n| not used.include?(n) }
  end
end
