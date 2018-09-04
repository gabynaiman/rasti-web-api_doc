module Rasti
  module Web
    module ApiDoc
      class Request

        def initialize(env)
          @env = env
        end

        def method
          env['REQUEST_METHOD']
        end

        def path_info
          env['PATH_INFO']
        end

        def route
          env['PATH_INFO'].dup.tap do |path_info|
            route_params.each do |name, value|
              path_info.sub! value, ":#{name}"
            end
          end
        end

        def route_params
          env['rack.request.route_params'] || {}
        end

        def query_params
          env['rack.request.query_hash'] || {}
        end

        def form_params
          env['rack.request.form_hash'] || {}
        end

        def headers
          headers = env.select { |k,v| k.start_with?('HTTP_') || k == 'CONTENT_TYPE' }
                       .map { |k,v| [k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-'), v] }
                       .sort
          Hash[headers]
        end

        private

        attr_reader :env

      end
    end
  end
end