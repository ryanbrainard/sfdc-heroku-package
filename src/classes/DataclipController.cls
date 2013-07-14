public class DataclipController {

    public String ySeries { get; set; }

    public String xSeries { get; set; }

    public String url { get; 
        set {
            url = value;
            load();
        } 
    }
    
    public DataclipResult result { get; private set; }
    
    public void load() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url + '.json');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        result = (DataclipResult) JSON.deserializeStrict(res.getBody(), DataclipResult.class);
    }    

}