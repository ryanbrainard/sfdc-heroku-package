@IsTest 
global class HttpCalloutSpy implements HttpCalloutMock {
    
    private HttpRequest req;
    private HttpResponse res;
    
    public HttpCalloutSpy(HttpResponse res) {
      this.res = res;
    }
    
    global HttpResponse respond(HttpRequest req) {
      this.req = req;
      return res;
    }
    
    public HttpRequest lastRequest() {
      return this.req;
    } 
}