require 'colorize'
require 'stringio'
require 'rake'
require 'rack/test'
require 'rasti/web'

require 'rasti/web/api_doc/request'
require 'rasti/web/api_doc/response'
require 'rasti/web/api_doc/task'
require 'rasti/web/api_doc/tracker'
require 'rasti/web/api_doc/version'

module Rasti
  module Web
    module ApiDoc
      
      def self.tracker
        @tracker
      end

      def self.tracker=(tracker)
        @tracker = tracker
      end

    end
  end
end

module Rack
  class MockSession

    alias_method :__request__, :request
    
    def request(uri, env)
      response = __request__ uri, env
      Rasti::Web::ApiDoc.tracker.track env, response
      response
    end

  end
end