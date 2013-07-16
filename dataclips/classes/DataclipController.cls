public class DataclipController {

    public String dataclipUrl { get; 
        set {
            dataclipUrl = value;
            load();
        } 
    }
    
    public DataclipResult result { get; private set; }
    
    public void load() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(dataclipUrl + '.json');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        result = (DataclipResult) JSON.deserializeStrict(res.getBody(), DataclipResult.class);
    }    

}