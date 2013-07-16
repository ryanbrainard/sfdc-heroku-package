@isTest
private class DataclipControllerTest {

  static testmethod void testLoading() {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"fields":["month","book_purchases"],"values":[["2011-01-01 00:00:00+00","747.58"],["2011-12-01 00:00:00+00","771.57"]]}');
    res.setStatusCode(200);
    HttpCalloutSpy spy = new HttpCalloutSpy(res);
    Test.setMock(HttpCalloutMock.class, spy);
    
    DataclipController c = new DataclipController();
    String plainUrl = 'https://dataclips.heroku.com/example';
    c.dataclipUrl = plainUrl;

    HttpRequest req = spy.lastRequest(); 
    System.assertEquals(plainUrl + '.json', req.getEndpoint());
    System.assertEquals('GET', req.getMethod());
    
    System.assertNotEquals(null, c.result);
  }
}