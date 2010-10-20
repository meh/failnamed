Gem::Specification.new {|s|
    s.name         = 'failnamed'
    s.version      = '0.0.1'
    s.author       = 'meh.'
    s.email        = 'meh@paranoici.org'
    s.homepage     = 'http://github.com/meh/failnamed'
    s.platform     = Gem::Platform::RUBY
    s.summary      = 'Fail Ruby named implementation'
    s.files        = Dir.glob('lib/**/*.rb')
    s.require_path = 'lib'
    s.executables  = ['failnamed']
    s.has_rdoc     = true

    s.add_dependency('faildns')
}
