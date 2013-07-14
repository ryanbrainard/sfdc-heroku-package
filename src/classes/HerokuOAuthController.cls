public class HerokuOAuthController {

    class InvalidCsrfException extends Exception {}
    class MultipleHerokuSessionException extends Exception {}
    
    public HerokuOAuthController(ApexPages.StandardController controller) { }

    public boolean getHasSession() {
        return HerokuApi.getSession() != null;    
    }
    
    public HerokuApi.HerokuAccount getHerokuAccount() {
        return new HerokuApi().getAccount();
    }

    public PageReference invalidateSession() {
        DELETE initHerokuSession();
        PageReference curr = ApexPages.currentPage();
        curr.setRedirect(true);
        return curr;
    }
    
    public PageReference authorize() {
        String key = (String) Heroku_OAuth_Config__c.getValues('sfdc-heroku-link').get('key__c');
        String csrf = String.valueOf(Crypto.getRandomLong());
        
        HerokuSession__c hsession = initHerokuSession();
        hsession.csrfToken__c = csrf;
        UPSERT hsession; 
        
        return new PageReference('https://id.heroku.com/oauth/authorize?client_id=' + key + '&response_type=code&state=' + csrf);
    }

    public void handleCallback() {
        String code = ApexPages.currentPage().getParameters().get('code');
        String csrf = ApexPages.currentPage().getParameters().get('state');
        Map<String,Object> auth = authenticate(code);
        HerokuSession__c hsession = initHerokuSession();
        validateCsrf(csrf, hsession);
        UPSERT fillHerokuSession(auth, hsession);
    }
                
    private Map<String,Object> authenticate(String code){
        Heroku_OAuth_Config__c config = Heroku_OAuth_Config__c.getValues('sfdc-heroku-link');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://id.heroku.com/oauth/token');
        Map<String,String> params = new Map<String,String>();
        params.put('grant_type', 'authorization_code');
        params.put('client_id', (String) config.get('key__c'));
        params.put('client_secret', (String) config.get('secret__c'));
        params.put('code', code);
        req.setBody(joinParams(params));
        req.setMethod('POST');
        HttpResponse res = new Http().send(req); 
        
        return (Map<String,Object>) JSON.deserializeUntyped(res.getBody());        
    } 
    
    private void validateCsrf(String csrf, HerokuSession__c hsession) {
        if (csrf != hsession.csrfToken__c) {
            System.debug('ACTUAL csrf: ' + csrf);
            System.debug('EXPECTED hsession.csrfToken__c: ' + hsession.csrfToken__c);
            throw new InvalidCsrfException();
        }
    }
    
    private HerokuSession__c initHerokuSession() {
        List<HerokuSession__c> hsessions = [SELECT Id, CsrfToken__c FROM HerokuSession__c WHERE ownerId = :UserInfo.getUserId()];
        
        if (hsessions.size() == 0) {
            return new HerokuSession__c(ownerId = UserInfo.getUserId());
        } else if (hsessions.size() == 1) {
            return hsessions.get(0);
        } else {
           throw new MultipleHerokuSessionException(); // TODO
        }
    }
    
    private HerokuSession__c fillHerokuSession(Map<String,Object> auth, HerokuSession__c hsession) {
        System.debug(auth);
        hsession.accessExpiry__c  = DateTime.now().addSeconds(Integer.valueOf(auth.get('expires_in')));
        hsession.accessToken__c   = (String) auth.get('access_token');
        hsession.refreshToken__c  = (String) auth.get('refresh_token');
        hsession.tokenType__c     = (String) auth.get('token_type');
        hsession.sessionNonce__c  = (String) auth.get('session_nonce');
        hsession.ownerId          = UserInfo.getUserId();
        return hsession;
    }
    
    private String joinParams(Map<String,String> params) {
        List<String> joined = new List<String>();
        for (String key : params.keySet()) {
            joined.add(key + '=' + params.get(key));
        }
        return String.join(joined, '&');
    }
}