import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class DistanceMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _debug as Boolean = false;
  private var _delegate as DataFieldSettingsMenuDelegate;
  private var _currentDistanceField as String = "";
  private var _currentPrompt as String = "";
  private var _currentMenuItem as MenuItem?;

  private var _distanceMenu as Menu2;
  private var _distanceItems as Array<String>;

  public function initialize(
    debug as Boolean,
    delegate as DataFieldSettingsMenuDelegate,
    distanceMenu as Menu2,
    distanceItems as Array<String>
  ) {
    Menu2InputDelegate.initialize();
    _debug = debug;
    _delegate = delegate;
    _distanceMenu = distanceMenu;
    _distanceItems = distanceItems;
  }

  public function onSelect(item as MenuItem) as Void {
    _currentDistanceField = item.getId() as String;
    _currentMenuItem = item;
    _currentPrompt = item.getLabel();

    var currentDistanceInKm = (($.getStorageValue(_currentDistanceField, 0.0f) as Float) / 1000).toFloat();
    var view = new $.NumericInputView(_debug, self, _currentPrompt, currentDistanceInKm);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view, self), WatchUi.SLIDE_RIGHT);
  }

  public function onAcceptNumericinput(distanceInKm as Float) as Void {
    try {
      if (_currentDistanceField.length() > 0) {
        var distanceInMeters = distanceInKm * 1000.0f;
        Storage.setValue(_currentDistanceField, distanceInMeters);

        // update menu sublabel
        if (_currentMenuItem != null) {
          var mi = _currentMenuItem as MenuItem;
          mi.setSubLabel($.getDistanceMenuSubLabel(mi.getId() as String));

          // index is a number
          var idx = _distanceItems.indexOf(mi.getId() as String);
          if (idx != null) {
            _distanceMenu.setFocus(idx);
          }
        }
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  public function onNumericinput(editData as Array<Char>, cursorPos as Number, insert as Boolean) as Void {
    // Hack to refresh screen
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    var view = new $.NumericInputView(_debug, self, _currentPrompt, 0.0f);
    view.setEditData(editData, cursorPos, insert);

    Toybox.WatchUi.pushView(view, new $.NumericInputDelegate(_debug, view, self), WatchUi.SLIDE_IMMEDIATE);
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class FieldsMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(menuItem as MenuItem) as Void {
    var id = menuItem.getId();
    if (id instanceof String && menuItem instanceof ToggleMenuItem) {
      Storage.setValue(id as String, menuItem.isEnabled());
    }
    //onBack();
    return;
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    // _delegate.onAcceptField();
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class FocusMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(item as MenuItem) as Void {
    Storage.setValue("showFocusSmallField", item.getId() as Types.EnumFocus);

    onBack();
    return;
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    _delegate.onAcceptFocus();
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class ToggleMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(menuItem as MenuItem) as Void {
    var id = menuItem.getId();
    if (id instanceof String && menuItem instanceof ToggleMenuItem) {
      Storage.setValue(id as String, menuItem.isEnabled());
    }
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class TrackMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(item as MenuItem) as Void {
    Storage.setValue("trackRecording", item.getId() as Types.EnumTrackRecording);
    onBack();
    return;
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    _delegate.onAcceptTrackRecording();
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class TireMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(item as MenuItem) as Void {
    Storage.setValue("tireRecording", item.getId() as Types.EnumTireRecording);
    onBack();
    return;
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    _delegate.onAcceptTireRecording();
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
class ChainMenuDelegate extends WatchUi.Menu2InputDelegate {
  private var _delegate as DataFieldSettingsMenuDelegate;

  public function initialize(delegate as DataFieldSettingsMenuDelegate) {
    Menu2InputDelegate.initialize();
    _delegate = delegate;
  }

  public function onSelect(item as MenuItem) as Void {
    Storage.setValue("chainRecording", item.getId() as Types.EnumChainRecording);
    onBack();
    return;
  }

  //! Handle the back key being pressed
  public function onBack() as Void {
    _delegate.onAcceptChainRecording();
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }

  //! Handle the done item being selected
  public function onDone() as Void {
    WatchUi.popView(WatchUi.SLIDE_DOWN);
  }
}
