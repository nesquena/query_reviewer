Gem::Specification.new do |s|
  s.name = 'query_reviewer'
  s.version = '0.1.4'
  s.author = 'dsboulder, nesquena'
  s.email = 'nesquena' + '@' + 'gmail.com'
  s.homepage = 'https://github.com/nesquena/query_reviewer'
  s.summary = 'Runs explain before each select query and displays results in an overlayed div'
  s.description = s.summary
  s.files = %w[MIT-LICENSE Rakefile README.md query_reviewer_defaults.yml] + Dir["lib/**/*"]
end