class Stock
  module Operation
    class Import < Trailblazer::Operation
      step :uri
      step :model
      step Nested Files::Operation::Download
      step Nested Files::Operation::Extract
      step :csv
      step :swap_with_temp_model
      step :table_name
      step Nested Task::TruncateTable
      step Nested Task::ImportCSV

      step :delete_tmp_files
      fail :delete_tmp_files

      def uri(ctx, stock:, **)
        ctx[:uri] = stock.uri
      end

      def model(ctx, stock:, **)
        ctx[:model] = stock.class::RELATED_MODEL
      end

      def csv(ctx, extracted_file:, **)
        ctx[:csv] = extracted_file
      end

      def swap_with_temp_model(ctx, model:, **)
        temp_model_name = "TmpModel#{model.name}"

        Object.const_set(temp_model_name, Class.new(model)) unless Object.const_defined?(temp_model_name)

        temp_model = temp_model_name.constantize
        temp_model.table_name = model.table_name + '_tmp'

        ctx[:model] = temp_model
      end

      def table_name(ctx, model:, **)
        ctx[:table_name] = model.table_name
      end

      def delete_tmp_files(_, file_path:, extracted_file:, **)
        FileUtils.rm_rf file_path
        FileUtils.rm_rf extracted_file
      end
    end
  end
end
