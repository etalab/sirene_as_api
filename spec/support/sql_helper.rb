def wrap_with_table_renamed(model)
  model.table_name = model.table_name + '_tmp'
  item = yield
  model.table_name.slice!('_tmp')
  item
end

def get_raw_data(table_name)
  sql = "SELECT * from #{table_name}"
  ActiveRecord::Base.connection.execute sql
end
