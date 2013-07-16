public class HerokuAppsComponentController {

    private HerokuApi api = new HerokuApi();
    
    public List<HerokuApi.HerokuApp> apps { 
        get {
            return api.getApps();
        }
    }
}