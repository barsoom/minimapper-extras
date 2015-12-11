require "bundler/gem_tasks"

desc "Run specs"
task :spec do
  system("bundle exec rspec #{Dir.glob("spec/**/*_spec.rb").join(' ')}") || exit(1)
end

task default: :spec
