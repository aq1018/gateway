require 'rspec/core'
require 'rspec/core/rake_task'

desc 'run all tests'
task :spec => %w[ spec:unit spec:integration ]

namespace :spec do
  desc "Run all tests with code coverage"
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task["spec"].execute
  end

  desc "Run integration tests"
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
  end

  namespace :integration do
    desc "Run integration tests with code coverage"
    task :coverage do
      ENV['COVERAGE'] = 'true'
      Rake::Task["spec:integration"].execute
    end
  end

  desc "Run unit tests"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  namespace :unit do
    desc "Run unit test with code coverage"
    task :coverage do
      ENV['COVERAGE'] = 'true'
      Rake::Task["spec:unit"].execute
    end
  end
end


task :test => 'spec'
