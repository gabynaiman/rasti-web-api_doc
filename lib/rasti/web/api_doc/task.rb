module Rasti
  module Web
    module ApiDoc
      class Task < Rake::TaskLib

        attr_reader :name
        attr_accessor :env, :app, :output, :pattern, :path

        def initialize(name=:doc)
          @name = name
          @output = 'API.md'
          @pattern = 'spec/**/*_spec.rb'
          @path = 'spec'
          
          yield self if block_given?

          build_task
        end

        private

        def build_task
          desc 'Build API documentation'
          task name do
            ENV['RACK_ENV'] ||= 'test'
            require env if env
            application = app.split('::').inject(Object) { |c,n| c.const_get(n) }

            Rasti::Web::ApiDoc.tracker = Tracker.new application.all_routes

            disable_test_runner_output
           
            at_exit do
              write_file
              print_summary
            end

            run_all_tests
          end
        end

        def disable_test_runner_output
          $stdout = StringIO.new
          $stderr = StringIO.new
        end

        def run_all_tests
          STDOUT.puts 'Building documentation'
          $LOAD_PATH.unshift path
          Dir.glob(File.expand_path(pattern)).each { |f| require f }
        end

        def write_file
          File.open(File.expand_path(output), 'w') do |f|
            f.puts '# **Endpoints**'

            Rasti::Web::ApiDoc.tracker.tracks.each do |method, routes|
              f.puts "\n## #{method}"
              routes.each do |route, info|
                f.puts "\n### **#{route}**"
                if info
                  request, response = info
                  
                  f.puts "**REQUEST**"
                  f.puts "- Path info: #{request.path_info}"
                  f.puts '- Headers' unless request.headers.empty?
                  request.headers.each do |name, value|
                    f.puts "  - #{name}: #{value}"
                  end
                  f.puts '- Route params' unless request.route_params.empty?
                  request.route_params.each do |name, value|
                    f.puts "  - #{name}: #{value}"
                  end
                  f.puts '- Query params' unless request.query_params.empty?
                  request.query_params.each do |name, value|
                    f.puts "  - #{name}: #{value}"
                  end
                  f.puts '- Form params' unless request.form_params.empty?
                  request.form_params.each do |name, value|
                    f.puts "  - #{name}: #{value}"
                  end
                  
                  f.puts "\n**RESPONSE**"
                  f.puts "- Status: #{response.status}"
                  f.puts '- Headers' unless response.headers.empty?
                  response.headers.each do |name, value|
                    f.puts "  - #{name}: #{value}"
                  end
                  f.puts "- Body: #{response.body}"
                else
                  f.puts "Pending"
                end
              end
              f.puts "\n---"
            end
          end
        end

        def print_summary
          summary = Rasti::Web::ApiDoc.tracker.summary

          STDOUT.puts "\nPending endpoints" unless summary[:pending_list].empty?
          summary[:pending_list].each do |method, routes|
            routes.each do |route|
              STDOUT.puts "  #{Colorin.amber_300(method.ljust(6, ' ')).bold} #{route}"
            end
          end

          STDOUT.puts
          STDOUT.print Colorin.blue_a700("#{summary[:endpoints]} endpoints")
          STDOUT.print ", "
          STDOUT.print Colorin.green_500("#{summary[:documented]} documented")
          STDOUT.print ", "
          STDOUT.puts Colorin.amber_300("#{summary[:pending]} pending")
        end

      end
    end
  end
end
