import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

//! The settings menu
class DataFieldSettingsMenu extends WatchUi.Menu2 {
  //! Constructor
  public function initialize() {
    Menu2.initialize({ :title => "Settings" });
  }
}

//! Handles menu input and stores the menu data
class DataFieldSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
  // private var _currentMenuItem as MenuItem?;
  // private var _view as DataFieldSettingsView;

  //! Constructor
  public function initialize() {
    Menu2InputDelegate.initialize();
    // _view = view;
  }

  //! Handle a menu item selection
  //! @param menuItem The selected menu item
  public function onSelect(item as MenuItem) as Void {
    // _currentMenuItem = item;
    var id = item.getId();
    if (id instanceof String && id.equals("menuDistance")) {
      var distanceMenu = new WatchUi.Menu2({ :title => "Set distance for" });

      var mi = new WatchUi.MenuItem("Odo |. (km/0.001)", null, "totalDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Year |. (km/0.001)", null, "totalDistanceYear", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Month |. (km/0.001)", null, "totalDistanceMonth", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Week |. (km/0.001)", null, "totalDistanceWeek", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Track |. (km/0.001)", null, "totalDistanceTrack", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      var tr = $.getStorageValue("tireRecording", TireRecProfile) as EnumTireRecording;
      var labelTireRec = $.getTireRecordingAsString(tr);
      if (labelTireRec.equals("default")) {
        labelTireRec = "";
      } else {
        labelTireRec = " for " + labelTireRec;
      }
      var trp = $.getTireRecPostfix();
      mi = new WatchUi.MenuItem("Front " + labelTireRec + " |. (km/0.001)", null, "totalDistanceFrontTyre" + trp, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Back " + labelTireRec + " |. (km/0.001)", null, "totalDistanceBackTyre" + trp, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      var cr = $.getChainRecPostfix();
      mi = new WatchUi.MenuItem("Chain " + labelTireRec + " |. (km/0.001)", null, "totalDistanceChain" + cr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Max Odo |. (km/0.001)", null, "maxDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Last year |. (km/0.001)", null, "totalDistanceLastYear", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Last month |. (km/0.001)", null, "totalDistanceLastMonth", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Last week |. (km/0.001)", null, "totalDistanceLastWeek", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Last track |. (km/0.001)", null, "totalDistanceLastTrack", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Last ride |. (km/0.001)", null, "totalDistanceLastRide", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem(
        "Max front " + labelTireRec + " |. (km/0.001)",
        null,
        "maxDistanceFrontTyre" + trp,
        null
      );
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Max back " + labelTireRec + " |. (km/0.001)", null, "maxDistanceBackTyre" + trp, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      mi = new WatchUi.MenuItem("Max chain " + labelTireRec + " |. (km/0.001)", null, "maxDistanceChain" + trp, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      // Not needed, is actual activity ride
      mi = new WatchUi.MenuItem("Elapsed (debug) |. (km/0.001)", null, "debugElapsedDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);

      WatchUi.pushView(distanceMenu, new $.GeneralMenuDelegate(self, distanceMenu), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("resetOptions")) {
      var resetMenu = new WatchUi.Menu2({ :title => "Reset options" });
      var boolean = $.getStorageValue("reset_front", false) as Boolean;
      resetMenu.addItem(new WatchUi.ToggleMenuItem("Reset front", null, "reset_front", boolean, null));

      boolean = $.getStorageValue("reset_back", false) as Boolean;
      resetMenu.addItem(new WatchUi.ToggleMenuItem("Reset back", null, "reset_back", boolean, null));

      boolean = $.getStorageValue("switch_front_back", false) as Boolean;
      resetMenu.addItem(new WatchUi.ToggleMenuItem("Front <-> back", null, "switch_front_back", boolean, null));

      boolean = $.getStorageValue("reset_chain", false) as Boolean;
      resetMenu.addItem(new WatchUi.ToggleMenuItem("Reset chain", null, "reset_chain", boolean, null));

      boolean = $.getStorageValue("reset_track", false) as Boolean;
      resetMenu.addItem(new WatchUi.ToggleMenuItem("Reset track", null, "reset_track", boolean, null));

      WatchUi.pushView(resetMenu, new $.GeneralMenuDelegate(self, resetMenu), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("showOptions")) {
      var showMenu = new WatchUi.Menu2({ :title => "Show options" });

      var boolean = $.getStorageValue("showColors", true) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Colors", null, "showColors", boolean, null));
      boolean = $.getStorageValue("showValues", true) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Values", null, "showValues", boolean, null));
      boolean = $.getStorageValue("showColorsSmallField", true) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Colors small field", null, "showColorsSmallField", boolean, null));
      boolean = $.getStorageValue("showValuesSmallField", false) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Values small field", null, "showValuesSmallField", boolean, null));
      boolean = $.getStorageValue("showLastDistance", false) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Last distance", null, "showLastDistance", boolean, null));
      boolean = $.getStorageValue("showDateNumbers", false) as Boolean;
      showMenu.addItem(new WatchUi.ToggleMenuItem("Date numbers", null, "showDateNumbers", boolean, null));

      WatchUi.pushView(showMenu, new $.GeneralMenuDelegate(self, showMenu), WatchUi.SLIDE_UP);
      return;
    }

    if (id instanceof String && id.equals("showFocusSmallField")) {
      var sp = new selectionMenuPicker("Show focus on", id as String);

      for (var i = 0; i < 10; i++) {
        var ft = i as EnumFocus;
        if (ft != FocusFront && ft != FocusBack) {
          sp.add($.getFocusAsString(ft), null, i);
        }
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("trackRecording")) {
      var sp = new selectionMenuPicker("Track recording active", id as String);

      for (var i = 0; i < 4; i++) {
        sp.add($.getTrackRecordingAsString(i as EnumTrackRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("tireRecording")) {
      var sp = new selectionMenuPicker("Tire recording f/b", id as String);

      for (var i = 0; i < 6; i++) {
        sp.add($.getTireRecordingAsString(i as EnumTireRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("chainRecording")) {
      var sp = new selectionMenuPicker("Chain recording", id as String);

      for (var i = 0; i < 7; i++) {
        sp.add($.getChainRecordingAsString(i as EnumChainRecording), null, i);
      }

      sp.setOnSelected(self, :onSelectedSelection, item);
      sp.show();
      return;
    }

    if (id instanceof String && id.equals("menuFields")) {
      var fieldsMenu = new WatchUi.Menu2({ :title => "Show fields" });

      var boolean = $.getStorageValue("showOdo", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show odo", null, "showOdo", boolean, null));

      boolean = $.getStorageValue("showYear", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show year", null, "showYear", boolean, null));
      boolean = $.getStorageValue("showMonth", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show month", null, "showMonth", boolean, null));
      boolean = $.getStorageValue("showWeek", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show week", null, "showWeek", boolean, null));
      boolean = $.getStorageValue("showRide", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show ride", null, "showRide", boolean, null));
      boolean = $.getStorageValue("showTrack", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show track", null, "showTrack", boolean, null));
      boolean = $.getStorageValue("showFront", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show front tyre", null, "showFront", boolean, null));
      boolean = $.getStorageValue("showBack", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show back tyre", null, "showBack", boolean, null));
      boolean = $.getStorageValue("showChain", true) as Boolean;
      fieldsMenu.addItem(new WatchUi.ToggleMenuItem("Show chain", null, "showChain", boolean, null));

      WatchUi.pushView(fieldsMenu, new $.GeneralMenuDelegate(self, fieldsMenu), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      return;
    }
    // if (WatchUi has :TextPicker) {
    //   WatchUi.pushView(
    //     new WatchUi.TextPicker(currentDistanceInKm.format("%d")),
    //     new $.KeyboardListener(_view, self),
    //     WatchUi.SLIDE_DOWN
    //   );
    // }
  }

  function onSelectedSelection(storageKey as String, value as Application.PropertyValueType) as Void {
    Storage.setValue(storageKey, value);
  }
}

//--
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _delegate as DataFieldSettingsMenuDelegate;
  hidden var _item as MenuItem?;
  hidden var _debug as Boolean = false;

  function initialize(delegate as DataFieldSettingsMenuDelegate, menu as WatchUi.Menu2) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  function onSelect(item as MenuItem) as Void {
    _item = item;
    var id = item.getId();

    // if (id instanceof String && id.equals("showInfoSmallField")) {
    //   var sp = new selectionMenuPicker("Small field", id as String);
    //   for (var i = 0; i <= 5; i++) {
    //     sp.add($.getShowInfoText(i), null, i);
    //   }
    //   sp.setOnSelected(self, :onSelectedSelection, item);
    //   sp.show();
    //   return;
    // }

    if (id instanceof String && item instanceof ToggleMenuItem) {
      Storage.setValue(id as String, item.isEnabled());
      return;
    }

    // Numeric input
    var prompt = item.getLabel();
    var value = $.getStorageValue(id as String, 0) as Numeric;
    var view = $.getNumericInputView(prompt, value);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_RIGHT);
  }

  function onAcceptNumericinput(value as Numeric, subLabel as String) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;

        Storage.setValue(storageKey, value);
        (_item as MenuItem).setSubLabel(subLabel);
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function onNumericinput(
    editData as Array<Char>,
    cursorPos as Number,
    insert as Boolean,
    negative as Boolean,
    opt as NumericOptions
  ) as Void {
    // Hack to refresh screen
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    var view = new $.NumericInputView("", 0);
    view.processOptions(opt);
    view.setEditData(editData, cursorPos, insert, negative);
    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_IMMEDIATE);
  }

  //! Handle the back key being pressed

  function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected

  function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  function onSelectedSelection(storageKey as String, value as Application.PropertyValueType) as Void {
    Storage.setValue(storageKey, value);
  }
}
