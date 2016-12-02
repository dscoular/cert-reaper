require 'rake/testtask'

# Tasks
namespace :foreman_my_plugin do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanMyPlugin'
  Rake::TestTask.new(:foreman_my_plugin) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_my_plugin do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_my_plugin) do |task|
        task.patterns = ["#{ForemanMyPlugin::Engine.root}/app/**/*.rb",
                         "#{ForemanMyPlugin::Engine.root}/lib/**/*.rb",
                         "#{ForemanMyPlugin::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_my_plugin'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_my_plugin']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_my_plugin', 'foreman_my_plugin:rubocop']
end
