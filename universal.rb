# Universal for Ruby
# Import/filter by:
# - intent
# - symbolic name
# - parameters
# - custom filtering (criteria). like in OSGi bundles
# - author
# - signed/trusted certs/GPG keys

# implicit/yield can't be worked out, Ruby 1.8 doesn't support closure inside closure
# need to use (strict) lambda functions

# http://practicalruby.blogspot.com/2007/02/ruby-metaprogramming-introduction.html
class ::Object
  def define_singleton_method name, &body
    singleton_class = class << self; self; end
    singleton_class.send(:define_method, name, &body)
  end
end

# Import by exact name, same 
def uni_import(name)
  name = name.to_s
  sanitized_name = name.gsub(/[^a-z_]/, '')
  unique_name = sanitized_name + '_impl'
  obj = Object.new
  cls = obj.instance_eval { class << self; self; end }
  cls.class_eval { load "#{sanitized_name}.rb" }
  define_singleton_method sanitized_name do |*args|
    puts 'Calling remote proc: '+ sanitized_name + '('+ args.join(',') +')'
    obj.send name, *args
    puts 'End proc: '+ sanitized_name
  end
#  cls = Class.new
#  cls.class_eval {
#  	load "#{sanitized_name}.rb"
#  }
#  obj = cls.new
#  singleton_class = class << self; self; end
#  singleton_class.class_eval {
#    def method_missing(method, *args, &block)
#    #send :define_method, :sanitized_name.to_sym do |*args|
#        puts 'Calling remote proc: '+ method + '('+ args.join(',') +')'
#        obj.send name, *args if name == sanitized_name
#        puts 'End proc: '+ method
#    end
#  }
end
