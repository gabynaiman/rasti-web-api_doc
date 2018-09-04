module Rasti
  module Web
    module ApiDoc
      class Tracker

        attr_reader :tracks        

        def initialize(routes_by_method)
          @tracks = Hash.new { |h,k| h[k] = {} }
          routes_by_method.each do |method, routes| 
            routes.each do |route| 
              tracks[method][route] = nil
            end
          end
        end

        def track(env, response)
          req = Rasti::Web::ApiDoc::Request.new(env)
          res = Rasti::Web::ApiDoc::Response.new(*response)

          if !tracks[req.method][req.route]
            STDOUT.puts "  #{Colorin.green_500(req.method.ljust(6, ' ')).bold} #{req.route}"
            tracks[req.method][req.route] = [req, res]
          end
        end

        def summary
          endpoints = tracks.values.flat_map(&:keys).count
          documented = tracks.values.flat_map(&:values).compact.count
          pending = Hash[tracks.map { |method, routes| [method, routes.select { |route, info| info.nil? }.keys ] }].select { |method, routes| !routes.empty? }

          {
            endpoints: endpoints,
            documented: documented,
            pending: pending.values.map(&:count).sum,
            pending_list: pending
          }
        end

      end
    end
  end
end