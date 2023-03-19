import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var gShowColors as Boolean = true;
var gShowValues as Boolean = true;
var gShowColorsSmallField as Boolean = true;
var gShowValuesSmallField as Boolean = false;
var gShowCurrentProfile as Boolean = false;
var gShowFocusSmallField as Types.EnumFocus = Types.FocusNothing;

class whattiredApp extends Application.AppBase {
    var mTotals as Totals = new Totals();

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        mTotals.save();
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        loadUserSettings();
        return [ new whattiredView() ] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() { loadUserSettings(); }

    (:typecheck(disableBackgroundCheck))
    function loadUserSettings() as Void {
      try {
        System.println("Load usersettings");
        
        mTotals.load(true); 
        $.gShowColors = getApplicationProperty("showColors", true) as Boolean;   
        $.gShowValues = getApplicationProperty("showValues", true) as Boolean;  
        $.gShowColorsSmallField = getApplicationProperty("showColorsSmallField", true) as Boolean;   
        $.gShowValuesSmallField = getApplicationProperty("showValuesSmallField", false) as Boolean;  

        $.gShowFocusSmallField = getApplicationProperty("showFocusSmallField", 0) as Types.EnumFocus;           

        // $.gShowCurrentProfile = getApplicationProperty("showCurrentProfile", true) as Boolean;           

        System.println("loadUserSettings loaded");
      } catch (ex) {
        ex.printStackTrace();
      }
    }
}

function getApp() as whattiredApp {
    return Application.getApp() as whattiredApp;
}

