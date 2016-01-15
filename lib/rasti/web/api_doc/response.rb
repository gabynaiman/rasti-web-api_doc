module Rasti
  module Web
    module ApiDoc
      class Response

        attr_reader :status, :headers

        def initialize(status, headers, body_proxy)
          @status = status
          @headers = headers
          @body_proxy = body_proxy
        end

        def body
          @body_proxy.body
        end

      end
    end
  end
end