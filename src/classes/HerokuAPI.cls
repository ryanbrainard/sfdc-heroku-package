public class HerokuAPI {

    class NoHerokuSessionException extends Exception {}

    private HerokuSession__c hsession;
    
    public static HerokuSession__c getSession() {
        List<HerokuSession__c> hsessions = [SELECT Id, AccessToken__c FROM HerokuSession__c WHERE ownerId = :UserInfo.getUserId() AND AccessToken__c != NULL AND AccessExpiry__c > :DateTime.now()];
        if (hsessions.size() == 1) {
            return hsessions.get(0);
        } else {
            return null;
        }
    } 
    
    public HerokuAPI() {
        hsession = getSession();
        if (hsession == null) {
            throw new NoHerokuSessionException();
        }
    }
    
    private HttpResponse req(String method, String path) {    
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint('https://api.heroku.com/' + path);
        req.setHeader('Accept', 'application/vnd.heroku+json; version=3');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(':' + hsession.accessToken__c)));
        return new Http().send(req);
    }

    public HerokuApp getApp(String appName) {
        HttpResponse res = req('GET', 'apps/' + appName);
        return (HerokuApp) JSON.deserialize(res.getBody(), HerokuApp.class);
    }
    
    public List<HerokuApp> getApps() {
        HttpResponse res = req('GET', 'apps');
        return (List<HerokuApp>) JSON.deserialize(res.getBody(), List<HerokuApp>.class);
    }
    
    public HerokuAccount getAccount() {
        HttpResponse res = req('GET', 'account');
        System.debug(res.getBody());
        return (HerokuAccount) JSON.deserialize(res.getBody(), HerokuAccount.class);
    }
    
    public class HerokuApp {
        public String id { get; set; }
        public String name { get; set; }
        public String web_url { get; set; }
        public String stack { get; set; }
        public DateTime released_at  { get; set; }
        public String buildpack_provided_description { get; set; }
    }
    
    public class HerokuAccount {
        public String id { get; set; }
        public String email { get; set; }
    }
}