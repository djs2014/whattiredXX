import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var gShowColors as Boolean = true;
var gShowValues as Boolean = true;
var gShowLastDistance as Boolean = true;
var gShowColorsSmallField as Boolean = true;
var gShowValuesSmallField as Boolean = false;
var gShowCurrentProfile as Boolean = false;
var gShowFocusSmallField as Types.EnumFocus = Types.FocusRide;
var gTrackRecording as Types.EnumTrackRecording = Types.TrackRecAlways;
var gTrackRecordingActive as Boolean = true;
var gTireRecording as Types.EnumTireRecording = Types.TireRecDefault;
var gChainRecording as Types.EnumChainRecording = Types.ChainRecAsTire;
var gActivityProfileId as String = "";
var gActivityProfileName as String = "";
var gshowDateNumbers as Boolean = false;

var gShowOdo as Boolean = true;
var gShowYear as Boolean = true;
var gShowMonth as Boolean = true;
var gShowWeek as Boolean = true;
var gShowRide as Boolean = true;
var gShowTrack as Boolean = true;
var gShowFront as Boolean = true;
var gShowBack as Boolean = true;
var gShowChain as Boolean = true;
var gNrOfDefaultFields as Number = 5;
var gTireRecPostfix as String = "-";
var gChainRecPostfix as String = "-";

class whattiredApp extends Application.AppBase {
  var mTotals as Totals = new Totals();

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {}

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {}

  //! Return the initial view of your application here
  function getInitialView() as Array<Views or InputDelegates>? {
    loadUserSettings();
    return [new whattiredView()] as Array<Views or InputDelegates>;
  }

  //! Return the settings view and delegate for the app
  //! @return Array Pair [View, Delegate]
  public function getSettingsView() as Array<Views or InputDelegates>? {
    return [new $.DataFieldSettingsView(), new $.DataFieldSettingsDelegate()] as Array<Views or InputDelegates>;
  }

  function onSettingsChanged() {
    loadUserSettings();
  }

  function triggerFrontBack() as Void {
    mTotals.triggerFrontBack();
  }

  (:typecheck(disableBackgroundCheck))
  function loadUserSettings() as Void {
    try {
      System.println("Load usersettings");

      $.gTireRecording = $.getStorageValue("tireRecording", $.gTireRecording) as Types.EnumTireRecording;
      $.gChainRecording = $.getStorageValue("chainRecording", $.gChainRecording) as Types.EnumChainRecording;

      mTotals.load(true);
      $.gShowColors = $.getStorageValue("showColors", $.gShowColors ) as Boolean;
      $.gShowValues = $.getStorageValue("showValues", $.gShowValues) as Boolean;
      $.gShowLastDistance = $.getStorageValue("showLastDistance", $.gShowLastDistance) as Boolean;
      $.gShowColorsSmallField = $.getStorageValue("showColorsSmallField",  $.gShowColorsSmallField) as Boolean;
      $.gshowDateNumbers = $.getStorageValue("showDateNumbers", $.gshowDateNumbers) as Boolean;

      $.gShowFocusSmallField = $.getStorageValue("showFocusSmallField", gShowFocusSmallField) as Types.EnumFocus;
      $.gTrackRecording = $.getStorageValue("trackRecording", gTrackRecording) as Types.EnumTrackRecording;

      $.gShowOdo = $.getStorageValue("showOdo", $.gShowOdo) as Boolean;
      $.gShowYear = $.getStorageValue("showYear", $.gShowYear) as Boolean;
      $.gShowMonth = $.getStorageValue("showMonth", $.gShowMonth) as Boolean;
      $.gShowWeek = $.getStorageValue("showWeek", $.gShowWeek) as Boolean;
      $.gShowRide = $.getStorageValue("showRide", $.gShowRide) as Boolean;
      $.gShowTrack = $.getStorageValue("showTrack", $.gShowTrack) as Boolean;
      
      $.gShowFront = $.getStorageValue("showFront", $.gShowFront) as Boolean;
      $.gShowBack = $.getStorageValue("showBack", $.gShowBack) as Boolean;
      $.gShowChain = $.getStorageValue("showChain", $.gShowChain) as Boolean;

      $.gNrOfDefaultFields = 0;
      if ($.gShowOdo) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }
      if ($.gShowYear) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }
      if ($.gShowMonth) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }
      if ($.gShowWeek) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }
      if ($.gShowRide) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }
      if ($.gShowTrack) {
        $.gNrOfDefaultFields = $.gNrOfDefaultFields + 1;
      }

      $.gTrackRecordingActive =
        $.gTrackRecording == Types.TrackRecAlways ||
        ($.gTrackRecording == Types.TrackRecWhenVisible and $.gShowTrack) ||
        ($.gTrackRecording == Types.TrackRecWhenFocus and $.gShowFocusSmallField == Types.FocusTrack);

      System.println("loadUserSettings loaded");
    } catch (ex) {
      ex.printStackTrace();
    }
  }
}

function getApp() as whattiredApp {
  return Application.getApp() as whattiredApp;
}
