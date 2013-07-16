public class HerokuAppComponentController {

    private HerokuApi api = new HerokuApi();

    public String appName { get; set; }
    
    public HerokuApi.HerokuApp app { 
        get {
            return api.getApp(appName);
        }
    }
}