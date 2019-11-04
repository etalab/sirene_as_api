class Server
  module Operation
    class AuthorizeImport < Trailblazer::Operation
      step :safe_mode?, Output(:failure) => 'End.success'
      step Nested(Task::CheckAvailability), Output(:success) => 'End.success'

      def safe_mode?(_, options:, **)
        options[:safe]
      end
    end
  end
end
