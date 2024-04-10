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
  private var _currentMenuItem as MenuItem?;
  // private var _view as DataFieldSettingsView;

  //! Constructor
  public function initialize() {
    Menu2InputDelegate.initialize();
    // _view = view;
  }

  //! Handle a menu item selection
  //! @param menuItem The selected menu item
  public function onSelect(menuItem as MenuItem) as Void {
    _currentMenuItem = menuItem;
    var id = menuItem.getId();
    var distanceItems = [] as Array<String>;
    if (id instanceof String && id.equals("menuDistance")) {
      var distanceMenu = new WatchUi.Menu2({ :title => "Set distance for" });

      var mi = new WatchUi.MenuItem("Odo", null, "totalDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Year", null, "totalDistanceYear", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Month", null, "totalDistanceMonth", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Week", null, "totalDistanceWeek", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Track", null, "totalDistanceTrack", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      var labelTireRec = $.getTireRecordingSubLabel("tireRecording");
      if (labelTireRec.equals("default")) {
        labelTireRec = "";
      } else {
        labelTireRec = " for " + labelTireRec;
      }
      var tr = $.getTireRecPostfix();
      mi = new WatchUi.MenuItem("Front" + labelTireRec, null, "totalDistanceFrontTyre" + tr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Back " + labelTireRec, null, "totalDistanceBackTyre" + tr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      var cr = $.getChainRecPostfix();
      mi = new WatchUi.MenuItem("Chain " + labelTireRec, null, "totalDistanceChain" + cr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Max Odo", null, "maxDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Last year", null, "totalDistanceLastYear", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Last month", null, "totalDistanceLastMonth", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Last week", null, "totalDistanceLastWeek", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Last track", null, "totalDistanceLastTrack", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Last ride", null, "totalDistanceLastRide", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Max front" + labelTireRec, null, "maxDistanceFrontTyre" + tr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Max back" + labelTireRec, null, "maxDistanceBackTyre" + tr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      mi = new WatchUi.MenuItem("Max chain" + labelTireRec, null, "maxDistanceChain" + tr, null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      // Not needed, is actual activity ride
      mi = new WatchUi.MenuItem("Elapsed (debug)", null, "debugElapsedDistance", null);
      mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));
      distanceMenu.addItem(mi);
      distanceItems.add(mi.getId() as String);

      WatchUi.pushView(distanceMenu, new $.DistanceMenuDelegate(), WatchUi.SLIDE_UP);
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

      WatchUi.pushView(resetMenu, new $.GeneralMenuDelegate(), WatchUi.SLIDE_UP);
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

      WatchUi.pushView(showMenu, new $.GeneralMenuDelegate(), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("showFocusSmallField")) {
      var focusMenu = new WatchUi.Menu2({ :title => "Show focus on" });
      var current = $.getStorageValue(id as String, Types.FocusNothing) as Types.EnumFocus;
      focusMenu.addItem(new WatchUi.MenuItem("Nothing", null, Types.FocusNothing, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Odo", null, Types.FocusOdo, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Year", null, Types.FocusYear, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Month", null, Types.FocusMonth, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Week", null, Types.FocusWeek, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Ride", null, Types.FocusRide, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Track", null, Types.FocusTrack, {}));
      // focusMenu.addItem(new WatchUi.MenuItem("Front", null, Types.FocusFront, {}));
      // focusMenu.addItem(new WatchUi.MenuItem("Back", null, Types.FocusBack, {}));
      focusMenu.addItem(new WatchUi.MenuItem("Course", null, Types.FocusCourse, {}));
      focusMenu.setFocus(current); // 0-index
      WatchUi.pushView(focusMenu, new $.FocusMenuDelegate(self), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("trackRecording")) {
      var trackMenu = new WatchUi.Menu2({ :title => "Track recording active" });
      var current = $.getStorageValue(id as String, Types.TrackRecAlways) as Types.EnumTrackRecording;
      trackMenu.addItem(new WatchUi.MenuItem("Disabled", null, Types.TrackRecDisabled, {}));
      trackMenu.addItem(new WatchUi.MenuItem("Always on", null, Types.TrackRecAlways, {}));
      trackMenu.addItem(new WatchUi.MenuItem("When track field visible", null, Types.TrackRecWhenVisible, {}));
      trackMenu.addItem(new WatchUi.MenuItem("When track field focus", null, Types.TrackRecWhenFocus, {}));

      trackMenu.setFocus(current); // 0-index
      WatchUi.pushView(trackMenu, new $.TrackMenuDelegate(self), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("tireRecording")) {
      var tireMenu = new WatchUi.Menu2({ :title => "Tire recording f/b" });
      var current = $.getStorageValue(id as String, Types.TireRecDefault) as Types.EnumTireRecording;
      tireMenu.addItem(new WatchUi.MenuItem("Default", null, Types.TireRecDefault, {}));
      tireMenu.addItem(new WatchUi.MenuItem("Profile", null, Types.TireRecProfile, {}));
      tireMenu.addItem(new WatchUi.MenuItem("Set A", null, Types.TireRecSetA, {}));
      tireMenu.addItem(new WatchUi.MenuItem("Set B", null, Types.TireRecSetB, {}));
      tireMenu.addItem(new WatchUi.MenuItem("Set C", null, Types.TireRecSetC, {}));
      tireMenu.addItem(new WatchUi.MenuItem("Set D", null, Types.TireRecSetD, {}));

      tireMenu.setFocus(current); // 0-index
      WatchUi.pushView(tireMenu, new $.TireMenuDelegate(self), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && id.equals("chainRecording")) {
      var chainMenu = new WatchUi.Menu2({ :title => "Chain recording" });
      var current = $.getStorageValue(id as String, Types.ChainRecDefault) as Types.EnumChainRecording;
      chainMenu.addItem(new WatchUi.MenuItem("Default", null, Types.ChainRecDefault, {}));
      chainMenu.addItem(new WatchUi.MenuItem("Profile", null, Types.ChainRecProfile, {}));
      chainMenu.addItem(new WatchUi.MenuItem("As tire", null, Types.ChainRecAsTire, {}));
      chainMenu.addItem(new WatchUi.MenuItem("Set A", null, Types.ChainRecSetA, {}));
      chainMenu.addItem(new WatchUi.MenuItem("Set B", null, Types.ChainRecSetB, {}));
      chainMenu.addItem(new WatchUi.MenuItem("Set C", null, Types.ChainRecSetC, {}));
      chainMenu.addItem(new WatchUi.MenuItem("Set D", null, Types.ChainRecSetD, {}));

      chainMenu.setFocus(current); // 0-index
      WatchUi.pushView(chainMenu, new $.ChainMenuDelegate(self), WatchUi.SLIDE_UP);
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

      WatchUi.pushView(fieldsMenu, new $.GeneralMenuDelegate(), WatchUi.SLIDE_UP);
      return;
    }
    if (id instanceof String && menuItem instanceof ToggleMenuItem) {
      Storage.setValue(id as String, menuItem.isEnabled());
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

  public function onAcceptFocus() as Void {
    // update menu sublabel
    if (_currentMenuItem != null) {
      var mi = _currentMenuItem as MenuItem;
      var id = mi.getId();
      if (id instanceof String && (id as String).equals("showFocusSmallField")) {
        mi.setSubLabel($.getFocusMenuSubLabel(mi.getId() as String));
      }
    }
  }
  public function onAcceptTrackRecording() as Void {
    // update menu sublabel
    if (_currentMenuItem != null) {
      var mi = _currentMenuItem as MenuItem;
      var id = mi.getId();
      if (id instanceof String && (id as String).equals("trackRecording")) {
        mi.setSubLabel($.getTrackRecordingSubLabel(mi.getId() as String));
      }
    }
  }
  public function onAcceptTireRecording() as Void {
    // update menu sublabel
    if (_currentMenuItem != null) {
      var mi = _currentMenuItem as MenuItem;
      var id = mi.getId();
      if (id instanceof String && (id as String).equals("tireRecording")) {
        mi.setSubLabel($.getTireRecordingSubLabel(mi.getId() as String));
      }
    }
  }
  public function onAcceptChainRecording() as Void {
    // update menu sublabel
    if (_currentMenuItem != null) {
      var mi = _currentMenuItem as MenuItem;
      var id = mi.getId();
      if (id instanceof String && (id as String).equals("chainRecording")) {
        mi.setSubLabel($.getChainRecordingSubLabel(mi.getId() as String));
      }
    }
  }
}

//--
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate {
  hidden var _item as MenuItem?;
  hidden var _currentPrompt as String = "";
  hidden var _debug as Boolean = false;

  function initialize() {
    Menu2InputDelegate.initialize();
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

    // @@ TODO cleanup and refactor
    _currentPrompt = item.getLabel();
    var numericOptions = $.parseLabelToOptions(_currentPrompt);

    var currentValue = $.getStorageValue(id as String, 0) as Numeric;
    if (numericOptions.isFloat) {
      currentValue = currentValue.toFloat();
    }

    var view = new $.NumericInputView(_debug, _currentPrompt, currentValue);
    view.processOptions(numericOptions);

    view.setOnAccept(self, :onAcceptNumericinput);
    view.setOnKeypressed(self, :onNumericinput);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view), WatchUi.SLIDE_RIGHT);
  }

  // function onSelectedAfterXUnits(value as Object, storageKey as String) as Void {
  //   var unit = value as AfterXUnits;
  //   Storage.setValue(storageKey, unit);
  //   if (_item != null) {
  //     (_item as MenuItem).setSubLabel($.getStartAfterUnitsText(unit));
  //   }
  // }

  function onAcceptNumericinput(value as Numeric) as Void {
    try {
      if (_item != null) {
        var storageKey = _item.getId() as String;
        Storage.setValue(storageKey, value);

        switch (value) {
          case instanceof Long:
          case instanceof Number:
            (_item as MenuItem).setSubLabel(value.format("%.0d"));
            break;
          case instanceof Float:
          case instanceof Double:
            (_item as MenuItem).setSubLabel(value.format("%.2f"));
            break;
        }
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
    var view = new $.NumericInputView(_debug, _currentPrompt, 0);
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

  function onSelectedSelection(value as Object, storageKey as String) as Void {
    Storage.setValue(storageKey, value as Number);
  }
}
