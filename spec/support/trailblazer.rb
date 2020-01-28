module TrailblazerHelper
  module RSpec
    def trb_result_success
      trb_result(success: true)
    end

    def trb_result_success_with(ctx)
      dbl = trb_result_success
      ctx.each { |key, val| allow(dbl).to receive(:[]).with(key).and_return(val) }
      dbl
    end

    def trb_result_failure_with(ctx)
      dbl = trb_result_failure
      ctx.each { |key, val| allow(dbl).to receive(:[]).with(key).and_return(val) }
      dbl
    end

    def trb_result_failure
      trb_result(success: false)
    end

    def expect_to_call_nested_operation(operation)
      expect(operation).to receive(:call_with_circuit_interface).and_call_original
    end

    def expect_not_to_call_nested_operation(operation)
      expect(operation).not_to receive(:call_with_circuit_interface)
    end

    # TODO: stub a nested operation to return a fake object
    # Waiting issue https://github.com/trailblazer/trailblazer-operation/issues/32 to be solved

    private

    def trb_result(success:, **)
      dbl = instance_double(
        Trailblazer::Operation::Railway::Result,
        success?: success,
        failure?: !success
      )
      allow(dbl).to receive(:[]).and_return(nil)
      dbl
    end
  end
end
