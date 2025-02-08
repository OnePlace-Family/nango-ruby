module Nango
  module HTTPHeaders
    def add_headers(headers)
      @extra_headers = extra_headers.merge(headers.transform_keys(&:to_s))
    end

    private

    def headers
      nango_headers.merge(extra_headers)
    end

    def nango_headers
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@access_token}"
      }.compact
    end

    def extra_headers
      @extra_headers ||= {}
    end
  end
end
