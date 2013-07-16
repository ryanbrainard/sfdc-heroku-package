@IsTest
private class DataclipResultTest {

  static DataclipResult sample() {
    String resultJs = '{"fields":["month","book_purchases"],"values":[["2011-01-01 00:00:00+00","747.58"],["2011-12-01 00:00:00+00","771.57"]]}';
    return (DataclipResult) JSON.deserializeStrict(resultJs, DataclipResult.class);
  }
  
  static testmethod void testHeadersAndValues() {
    List<List<String>> hv = new List<List<String>>();
    
    List<String> h = new List<String>();
    h.add('month');
    h.add('book_purchases');
    hv.add(h);
    
    List<String> v1 = new List<String>();
    v1.add('2011-01-01 00:00:00+00');
    v1.add('747.58');
    hv.add(v1);
    
    List<String> v2 = new List<String>();
    v2.add('2011-12-01 00:00:00+00');
    v2.add('771.57');
    hv.add(v2);
    
    System.assertEquals(hv, sample().getHeadersAndValues());
  }
  
  static testmethod void testFieldSelectOptions() { 
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('month','month'));
    options.add(new SelectOption('book_purchases','book_purchases'));
    
    System.assertEquals(options, sample().getFieldSelectOptions());
  }
  
  static testmethod void testChartData() {
    List<Map<String,Object>> data = new List<Map<String,Object>>();
    
    Map<String,Object> row1 = new Map<String,Object>();
    row1.put('month', '2011-01-01 00:00:00+00');
    row1.put('book_purchases', '747.58');
    data.add(row1);
    
    Map<String,Object> row2 = new Map<String,Object>();
    row2.put('month', '2011-12-01 00:00:00+00');
    row2.put('book_purchases', '771.57');
    data.add(row2);
    
    System.assertEquals(data, sample().getChartData());
  }
}