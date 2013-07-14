public class DataclipResult {
  public List<String> fields { get; }
  public List<List<String>> values { get; }
  
  public List<List<String>> getHeadersAndValues() {
      List<List<String>> hv = new List<List<String>>();
      hv.add(fields);
      hv.addAll(values);
      return hv;
  }
  
  public List<SelectOption> getFieldSelectOptions() {
      List<SelectOption> options = new List<SelectOption>();
      
      for (String field : fields) {
          options.add(new SelectOption(field, field));
      }

      return options;
  }
  
  public List<Map<String,Object>> getChartData() {
      List<Map<String,Object>> data = new List<Map<String,Object>>();
      
      for (List<String> value : values) {
          Map<String,Object> row = new Map<String,Object>();
          Integer i = 0;
          for (String field : fields) {
              row.put(field, value.get(i++));
          }
          data.add(row);
      }

      return data;
  }
  

}