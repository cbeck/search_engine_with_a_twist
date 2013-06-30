module ActiveRecord
  class Base
      def self.count_since(time_ago)
        count(:conditions => ['created_at > ?', time_ago])
      end
  end
end

module ActionController
  module Routing
    class RouteSet
      def extract_request_environment(request)
        { :method => request.method, :hostname => request.host }
      end
    end
    class Route
      alias_method :old_recognition_conditions, :recognition_conditions
      def recognition_conditions
        result = old_recognition_conditions
        result << "env[:hostname] =~ conditions[:hostname]" if conditions[:hostname]
        result
      end
    end
  end
end