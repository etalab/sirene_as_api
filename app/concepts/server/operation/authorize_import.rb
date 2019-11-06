class Server
  module Operation
    class AuthorizeImport < Trailblazer::Operation
      step :safe_mode?, Output(:failure) => 'End.success'
      step Nested(Task::CheckAvailability)

      def safe_mode?(_, options:, **)
        options[:safe]
      end
    end
  end
end
