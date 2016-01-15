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
            application = Object.const_get app

            Rasti::Web::ApiDoc.tracker = Tracker.new application.all_routes

            # Hide test runner output
            $stdout = StringIO.new
            $stderr = StringIO.new
           
            at_exit do
              write_file
              print_summary
            end

            # Run all tests
            STDOUT.puts 'Building documentation'
            $LOAD_PATH.unshift path
            Dir.glob(File.expand_path(pattern)).each { |f| require f }
          end
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
              STDOUT.puts "  #{method} #{route}".red
            end
          end

          STDOUT.puts
          STDOUT.print "#{summary[:endpoints]} endpoints, "
          STDOUT.print "#{summary[:documented]} documented".colorize(summary[:documented] == 0 ? :white : :green)
          STDOUT.print ", "
          STDOUT.puts "#{summary[:pending]} pending".colorize(summary[:pending] == 0 ? :white : :red)
        end

      end
    end
  end
end