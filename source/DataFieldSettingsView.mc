//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

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
    mi.setSubLabel($.getFocusMenuSubLabel(mi.getId() as String));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Track recording", null, "trackRecording", null);
    mi.setSubLabel($.getTrackRecordingSubLabel(mi.getId() as String));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Tire recording", null, "tireRecording", null);
    mi.setSubLabel($.getTireRecordingSubLabel(mi.getId() as String));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Chain recording", null, "chainRecording", null);
    mi.setSubLabel($.getChainRecordingSubLabel(mi.getId() as String));
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Distance", null, "menuDistance", null);
    mi.setSubLabel("Manage distance settings");
    menu.addItem(mi);

    mi = new WatchUi.MenuItem("Show options", null, "showOptions", null);    
    menu.addItem(mi);
  
    mi = new WatchUi.MenuItem("Show fields", null, "menuFields", null);
    mi.setSubLabel("Display data");
    menu.addItem(mi);
   
    var view = new $.DataFieldSettingsView();
    WatchUi.pushView(menu, new $.DataFieldSettingsMenuDelegate(view), WatchUi.SLIDE_IMMEDIATE);
    return true;
  }

  public function onBack() as Boolean {
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

function getFocusMenuSubLabel(key as Application.PropertyKeyType) as String {
  var current = $.getStorageValue(key, $.gShowFocusSmallField) as Types.EnumFocus;
  switch (current) {
    case Types.FocusNothing:
      return "Nothing";
    case Types.FocusOdo:
      return "Odo";
    case Types.FocusYear:
      return "Year";
    case Types.FocusMonth:
      return "Month";
    case Types.FocusWeek:
      return "Week";
    case Types.FocusRide:
      return "Ride";
    // case Types.FocusFront:
    //   return "Front";
    // case Types.FocusBack:
    //   return "Back";
    case Types.FocusCourse:
      return "Course";
    case Types.FocusTrack:
      return "Track";
    default:
      return "Nothing";
  }
}

function getTrackRecordingSubLabel(key as Application.PropertyKeyType) as String {
  var current = $.getStorageValue(key, $.gTrackRecording) as Types.EnumTrackRecording;
  switch (current) {
    case Types.TrackRecDisabled:
      return "Disabled";
    case Types.TrackRecAlways:
      return "Always";
    case Types.TrackRecWhenFocus:
      return "When focused";
    case Types.TrackRecWhenVisible:
      return "When visible";
    default:
      return "Disabled";
  }
}

function getTireRecordingSubLabel(key as Application.PropertyKeyType) as String {
  var current = $.getStorageValue(key, $.gTireRecording) as Types.EnumTireRecording;
  switch (current) {
    case Types.TireRecDefault:
      return "default";
    case Types.TireRecProfile:
      return $.getProfileName("profile");
    case Types.TireRecSetA:
      return "tire A";
    case Types.TireRecSetB:
      return "tire B";
    case Types.TireRecSetC:
      return "tire C";
    case Types.TireRecSetD:
      return "tire D";          
    default:
      return "default";
  }
}
function getChainRecordingSubLabel(key as Application.PropertyKeyType) as String {
  var current = $.getStorageValue(key, $.gChainRecording) as Types.EnumChainRecording;
  switch (current) {
    case Types.ChainRecDefault:
      return "default";
    case Types.ChainRecProfile:
      return $.getProfileName("profile");
    case Types.ChainRecAsTire:
      return "as tire";      
    case Types.ChainRecSetA:
      return "chain A";
    case Types.ChainRecSetB:
      return "chain B";
    case Types.ChainRecSetC:
      return "chain C";
    case Types.ChainRecSetD:
      return "chain D";          
    default:
      return "default";
  }
}
