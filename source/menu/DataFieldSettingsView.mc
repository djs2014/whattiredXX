import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

var gExitedMenu as Boolean = false;

//! Initial view for the settings
class DataFieldSettingsView extends WatchUi.View {
  //! Constructor
  public function initialize() {
    View.initialize();
  }

  //! Update the view
  //! @param dc Device context
  public function onUpdate(dc as Dc) as Void {
    dc.clearClip();
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    var mySettings = System.getDeviceSettings();
    var version = mySettings.monkeyVersion;
    var versionString = Lang.format("$1$.$2$.$3$", version);

    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() / 2 - 30,
      Graphics.FONT_SMALL,
      "Press Menu \nfor settings \nCIQ " + versionString,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }
}

//! Handle opening the settings menu
class DataFieldSettingsDelegate extends WatchUi.BehaviorDelegate {
  //! Constructor
  public function initialize() {
    BehaviorDelegate.initialize();
  }

  //! Handle the menu event
  //! @return true if handled, false otherwise
  public function onMenu() as Boolean {
    var menu = new $.DataFieldSettingsMenu();

    var mi = new WatchUi.MenuItem("Reset options", null, "resetOptions", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Focus", null, "showFocusSmallField", null);
    var value = getStorageValue(mi.getId() as String, FocusNothing) as EnumFocus;
    mi.setSubLabel($.getFocusAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Track recording", null, "trackRecording", null);
    value = getStorageValue(mi.getId() as String, TrackRecAlways) as EnumTrackRecording;
    mi.setSubLabel($.getTrackRecordingAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Tire recording", null, "tireRecording", null);
    value = getStorageValue(mi.getId() as String, TireRecProfile) as EnumTireRecording;
    mi.setSubLabel($.getTireRecordingAsString(value));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Chain recording", null, "chainRecording", null);
    value = getStorageValue(mi.getId() as String, ChainRecAsTire) as EnumChainRecording;
    mi.setSubLabel($.getChainRecordingAsString(value));    
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Distance", null, "menuDistance", null);
    mi.setSubLabel("Manage distance settings");
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Show options", null, "showOptions", null);
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Show fields", null, "menuFields", null);
    mi.setSubLabel("Display data");
    menu.addItem(mi);

    WatchUi.pushView(menu, new $.DataFieldSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    return true;
  }

  public function onBack() as Boolean {
    $.gExitedMenu = true;
    getApp().onSettingsChanged();
    getApp().triggerFrontBack();
    return false;
  }
}

// Globals
//Always in km
function getDistanceMenuSubLabel(key as Application.PropertyKeyType) as String {
  return ((getStorageValue(key, 0.0f) as Float) / 1000).format("%.2f") + " km";
}

function getFocusAsString(value as EnumFocus) as String {
  switch (value) {
    case FocusNothing:
      return "Nothing";
    case FocusOdo:
      return "Odo";
    case FocusYear:
      return "Year";
    case FocusMonth:
      return "Month";
    case FocusWeek:
      return "Week";
    case FocusRide:
      return "Ride";
    case FocusFront:
      return "Front";
    case FocusBack:
      return "Back";
    case FocusCourse:
      return "Course";
    case FocusTrack:
      return "Track";
    default:
      return "Nothing";
  }
}

function getTrackRecordingAsString(value as EnumTrackRecording) as String {
  switch (value) {
    case TrackRecDisabled:
      return "Disabled";
    case TrackRecAlways:
      return "Always";
    case TrackRecWhenFocus:
      return "When focused";
    case TrackRecWhenVisible:
      return "When visible";
    default:
      return "Disabled";
  }
}

function getTireRecordingAsString(value as EnumTireRecording) as String {
  switch (value) {
    case TireRecDefault:
      return "default";
    case TireRecProfile:
      return $.getProfileName("profile");
    case TireRecSetA:
      return "tire A";
    case TireRecSetB:
      return "tire B";
    case TireRecSetC:
      return "tire C";
    case TireRecSetD:
      return "tire D";
    default:
      return "default";
  }
}

function getChainRecordingAsString(value as EnumChainRecording) as String {
  switch (value) {
    case ChainRecDefault:
      return "default";
    case ChainRecProfile:
      return $.getProfileName("profile");
    case ChainRecAsTire:
      return "as tire";
    case ChainRecSetA:
      return "chain A";
    case ChainRecSetB:
      return "chain B";
    case ChainRecSetC:
      return "chain C";
    case ChainRecSetD:
      return "chain D";
    default:
      return "default";
  }
}