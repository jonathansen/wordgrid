Gem::Specification.new do |s|
  s.name        = 'wordgrid'
  s.version     = File.exist?('VERSION') ? File.read('VERSION') : ""
  s.date        = '2012-04-15'
  s.summary     = "Wordgrid"
  s.description = "Visualizing and solving games like boggle, scramble with friends, etc"
  s.authors     = ["Jonathan Hansen"]
  s.email       = 'jonathansen@gmail.com'
  s.files       = ["lib/wordgrid.rb", "spec/wordgrid_spec.rb"]
  s.homepage    = 'https://github.com/jonathansen/wordgrid'
end
