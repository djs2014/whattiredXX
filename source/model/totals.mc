import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.System;
import Toybox.Activity;
import Toybox.Math;
import Toybox.StringUtil;
import Toybox.Attention;

class Totals {
  private var elapsedDistanceActivity as Float = 0.0f;
  private var elapsedAscentActivity as Number = 0;
  private var elapsedDescentActivity as Number = 0;
  private var debugElapsedDistance as Float = 0.0f;
  // odo
  private var totalDistance as Float = 0.0f;
  private var maxDistance as Float = 0.0f;

  private var lastYear as Number = 0;
  private var totalDistanceLastYear as Float = 0.0f;
  private var currentYear as Number = 0;
  private var totalDistanceYear as Float = 0.0f;

  private var totalDistanceLastMonth as Float = 0.0f;
  private var currentMonth as Number = 0;
  private var totalDistanceMonth as Float = 0.0f;

  private var currentWeek as Number = 0;
  private var totalDistanceLastWeek as Float = 0.0f;
  private var totalDistanceWeek as Float = 0.0f;

  private var totalDistanceLastTrack as Float = 0.0f;
  private var totalDistanceTrack as Float = 0.0f;
  private var totalAscentLastTrack as Number = 0;
  private var totalAscentTrack as Number = 0;
  private var totalDescentLastTrack as Number = 0;
  private var totalDescentTrack as Number = 0;

  private var totalDistanceLastRide as Float = 0.0f;
  private var totalDistanceRide as Float = 0.0f;
  private var startDistanceCourse as Float = 0.0f;
  private var totalDistanceToDestination as Float = 0.0f;

  private var rideStarted as Boolean = false;
  private var rideTimerState as Number = Activity.TIMER_STATE_OFF;

  private var totalDistanceFrontTyre as Float = 0.0f;
  private var maxDistanceFrontTyre as Float = 0.0f;
  private var totalDistanceBackTyre as Float = 0.0f;
  private var maxDistanceBackTyre as Float = 0.0f;
  private var totalDistanceChain as Float = 0.0f;
  private var maxDistanceChain as Float = 0.0f;

  hidden function GetElapsedDistance() as Float {
    return elapsedDistanceActivity + debugElapsedDistance;
  }
  public function GetTotalDistance() as Float {
    return totalDistance + GetElapsedDistance();
  }
  public function GetMaxDistance() as Float {
    return maxDistance;
  }
  public function GetTotalDistanceYear() as Float {
    return totalDistanceYear + GetElapsedDistance();
  }
  public function GetTotalDistanceMonth() as Float {
    return totalDistanceMonth + GetElapsedDistance();
  }
  public function GetTotalDistanceWeek() as Float {
    return totalDistanceWeek + GetElapsedDistance();
  }
  public function GetTotalDistanceTrack() as Float {
    if ($.gTrackRecordingActive) {
      return totalDistanceTrack + GetElapsedDistance();
    } else {
      return totalDistanceTrack;
    }
  }
  public function GetTotalAscentTrack() as Number {
    if ($.gTrackRecordingActive) {
      return totalAscentTrack + elapsedAscentActivity;
    } else {
      return totalAscentTrack;
    }
  }
  public function GetTotalDescentTrack() as Number {
    if ($.gTrackRecordingActive) {
      return totalDescentTrack + elapsedDescentActivity;
    } else {
      return totalDescentTrack;
    }
  }

  public function GetTotalDistanceRide() as Float {
    if (rideTimerState == Activity.TIMER_STATE_OFF) {
      return totalDistanceRide;
    }
    return GetElapsedDistance();
  }
  public function GetTotalDistanceLastYear() as Float {
    return totalDistanceLastYear;
  }
  public function GetTotalDistanceLastMonth() as Float {
    return totalDistanceLastMonth;
  }
  public function GetTotalDistanceLastWeek() as Float {
    return totalDistanceLastWeek;
  }
  public function GetTotalDistanceLastTrack() as Float {
    return totalDistanceLastTrack;
  }
  public function GetTotalAscentLastTrack() as Number {
    return totalAscentLastTrack;
  }
  public function GetTotalDescentLastTrack() as Number {
    return totalDescentLastTrack;
  }

  public function GetTotalDistanceLastRide() as Float {
    return totalDistanceLastRide;
  }
  public function GetElapsedDistanceToDestination() as Float {
    return GetElapsedDistance() - startDistanceCourse;
  }
  public function GetDistanceToDestination() as Float {
    return totalDistanceToDestination;
  }
  public function IsCourseActive() as Boolean {
    System.println("totalDistanceToDestination:");
    System.println(totalDistanceToDestination / 1000.0);
    System.println("GetElapsedDistanceToDestination()");
    System.println(GetElapsedDistanceToDestination() / 1000.0);
    System.println("startDistanceCourse()");
    System.println(startDistanceCourse / 1000.0);
    System.println("elapsedDistanceActivity");
    System.println(GetElapsedDistance() / 1000.0);

    return totalDistanceToDestination > 0;
  }

  public function IsActivityStopped() as Boolean {
    return rideTimerState == Activity.TIMER_STATE_STOPPED;
  }

  public function GetTotalDistanceFrontTyre() as Float {
    return totalDistanceFrontTyre + GetElapsedDistance();
  }
  public function GetMaxDistanceFrontTyre() as Float {
    return maxDistanceFrontTyre;
  }
  public function GetTotalDistanceBackTyre() as Float {
    return totalDistanceBackTyre + GetElapsedDistance();
  }
  public function GetMaxDistanceBackTyre() as Float {
    return maxDistanceBackTyre;
  }
  public function GetTotalDistanceChain() as Float {
    return totalDistanceChain + GetElapsedDistance();
  }
  public function GetMaxDistanceChain() as Float {
    return maxDistanceChain;
  }

  public function HasOdo() as Boolean {
    return $.gShowOdo;
  }
  public function HasYear() as Boolean {
    return $.gShowYear;
  }
  public function HasMonth() as Boolean {
    return $.gShowMonth;
  }
  public function HasWeek() as Boolean {
    return $.gShowWeek;
  }
  public function HasRide() as Boolean {
    return $.gShowRide;
  }
  public function HasTrack() as Boolean {
    return $.gShowTrack;
  }
  public function HasFrontTyre() as Boolean {
    return $.gShowFront; 
  }
  public function HasBackTyre() as Boolean {
    return $.gShowBack; 
  }
  public function HasChain() as Boolean {
    return $.gShowChain; 
  }

  public function GetCurrentWeek() as Number {
    return currentWeek;
  }
  public function GetCurrentMonth() as Number {
    return currentMonth;
  }
  public function GetCurrentYear() as Number {
    return currentYear;
  }

  function initialize() {}

  function compute(info as Activity.Info) as Void {
    if (info has :elapsedDistance) {
      if (info.elapsedDistance != null) {
        elapsedDistanceActivity = info.elapsedDistance as Float;
      } else {
        elapsedDistanceActivity = 0.0f;
      }
    }

    if (info has :totalAscent) {
      if (info.totalAscent != null) {
        elapsedAscentActivity = info.totalAscent as Number;
      } else {
        elapsedAscentActivity = 0;
      }
    }
    if (info has :totalDescent) {
      if (info.totalDescent != null) {
        elapsedDescentActivity = info.totalDescent as Number;
      } else {
        elapsedDescentActivity = 0;
      }
    }

    if (info has :timerState) {
      if (info.timerState != null) {
        rideTimerState = info.timerState as Number;
        if (rideTimerState == Activity.TIMER_STATE_STOPPED or rideTimerState == Activity.TIMER_STATE_OFF) {
          rideStarted = false;
        }
        if (!rideStarted && rideTimerState == Activity.TIMER_STATE_ON) {
          handleRide();
        }
      }
    }

    totalDistanceToDestination = 0.0f;
    if (info has :distanceToDestination) {
      if (info.distanceToDestination != null) {
        totalDistanceToDestination = info.distanceToDestination as Float;
      }
    }
    // Remeber the distance, when course is started
    if (totalDistanceToDestination == 0.0f) {
      startDistanceCourse = 0.0f;
    } else if (startDistanceCourse == 0.0f) {
      startDistanceCourse = GetElapsedDistance();
    }
  }

  function save(loadValues as Boolean) as Void {
    try {
      setDistanceAsMeters("totalDistance", totalDistance + GetElapsedDistance());

      saveYear();
      saveMonth();
      saveWeek();

      loadTireDistance(false);
      var trp = $.getTireRecPostfix();
      setDistanceAsMeters("totalDistanceFrontTyre" + trp, totalDistanceFrontTyre + GetElapsedDistance());
      setDistanceAsMeters("totalDistanceBackTyre" + trp, totalDistanceBackTyre + GetElapsedDistance());

      loadChainDistance(false);
      var cr = $.getChainRecPostfix();
      setDistanceAsMeters("totalDistanceChain" + cr, totalDistanceChain + GetElapsedDistance());

      if ($.gTrackRecordingActive) {
        saveTrack();
      }

      saveRide();
      if (debugElapsedDistance>0) {
        debugElapsedDistance = 0.0f;
        setDistanceAsMeters("debugElapsedDistance", debugElapsedDistance);
        System.println("debugElapsedDistance reset to 0");
      }
      System.println("save completed");

      if (loadValues) {
        load(false);
      }

      System.println(
        Lang.format("save: rideStarted [$1$] ride [$2$] last ride [$3$] loadValues[$4$]", [
          rideStarted,
          GetElapsedDistance(),
          totalDistanceLastRide,
          loadValues
        ])
      );
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function saveYear() as Void {
    Toybox.Application.Storage.setValue("lastYear", lastYear);
    setDistanceAsMeters("totalDistanceLastYear", totalDistanceLastYear);

    Toybox.Application.Storage.setValue("currentYear", currentYear);
    setDistanceAsMeters("totalDistanceYear", totalDistanceYear + GetElapsedDistance());
  }
  function saveMonth() as Void {
    Toybox.Application.Storage.setValue("currentMonth", currentMonth);
    setDistanceAsMeters("totalDistanceLastMonth", totalDistanceLastMonth);
    setDistanceAsMeters("totalDistanceMonth", totalDistanceMonth + GetElapsedDistance());
  }
  function saveWeek() as Void {
    Toybox.Application.Storage.setValue("currentWeek", currentWeek);
    setDistanceAsMeters("totalDistanceLastWeek", totalDistanceLastWeek);
    setDistanceAsMeters("totalDistanceWeek", totalDistanceWeek + GetElapsedDistance());
  }
  function saveRide() as Void {
    // if (totalDistanceLastRide > 500.0) {
    //   setDistanceAsMeters("totalDistanceLastRide", totalDistanceLastRide);
    // }
    setDistanceAsMeters("totalDistanceRide", GetElapsedDistance());
    totalDistanceRide = GetElapsedDistance();
  }

  function saveTrack() as Void {
    setDistanceAsMeters("totalDistanceLastTrack", totalDistanceLastTrack);
    setDistanceAsMeters("totalDistanceTrack", totalDistanceTrack + GetElapsedDistance());

    Storage.setValue("totalAscentLastTrack", totalAscentLastTrack);
    Storage.setValue("totalAscentTrack", totalAscentTrack + elapsedAscentActivity);
    Storage.setValue("totalDescentLastTrack", totalDescentLastTrack);
    Storage.setValue("totalDescentTrack", totalDescentTrack + elapsedDescentActivity);
  }

  // Storage values are in meters, (overrule) properties are in kilometers!
  // Save will happen during pause / stop switch to connect iq widget
  // so load values and correct with elapsed distance.
  function load(processDate as Boolean) as Void {
    totalDistance = getDistanceAsMeters("totalDistance");
    maxDistance = getDistanceAsMeters("maxDistance");

    lastYear = $.getStorageValue("lastYear", 0) as Number;
    totalDistanceLastYear = getDistanceAsMeters("totalDistanceLastYear");
    currentYear = $.getStorageValue("currentYear", 0) as Number;
    totalDistanceYear = getDistanceAsMeters("totalDistanceYear");

    currentMonth = $.getStorageValue("currentMonth", 0) as Number;
    totalDistanceLastMonth = getDistanceAsMeters("totalDistanceLastMonth");
    totalDistanceMonth = getDistanceAsMeters("totalDistanceMonth");

    currentWeek = $.getStorageValue("currentWeek", 0) as Number;
    totalDistanceLastWeek = getDistanceAsMeters("totalDistanceLastWeek");
    totalDistanceWeek = getDistanceAsMeters("totalDistanceWeek");

    totalDistanceLastTrack = getDistanceAsMeters("totalDistanceLastTrack");
    totalDistanceTrack = getDistanceAsMeters("totalDistanceTrack");

    totalAscentLastTrack = $.getStorageValue("totalAscentLastTrack", 0) as Number;
    totalAscentTrack = $.getStorageValue("totalAscentTrack", 0) as Number;
    totalDescentLastTrack = $.getStorageValue("totalDescentLastTrack", 0) as Number;
    totalDescentTrack = $.getStorageValue("totalDescentTrack", 0) as Number;

    totalDistanceLastRide = getDistanceAsMeters("totalDistanceLastRide");
    totalDistanceRide = getDistanceAsMeters("totalDistanceRide");
    debugElapsedDistance = getDistanceAsMeters("debugElapsedDistance");

    System.println(
      Lang.format("load: rideStarted [$1$] ride [$2$] last ride [$3$] ", [
        rideStarted,
        totalDistanceRide,
        totalDistanceLastRide,
      ])
    );

    if (processDate) {
      handleDate();
    }

    // @@ TODO
    // Add prefix , if switch tirerec then load the last values
    // onCompute -> detect profile switch?
    $.gTireRecPostfix = "";
    loadTireDistance(true);
    $.gChainRecPostfix = "";
    loadChainDistance(true);
  }

  function loadTireDistance(force as Boolean) as Void {
    var trp = $.getTireRecPostfix();
    if (!force and trp.equals($.gTireRecPostfix)) {
      System.println("Tire distance already loaded for: " + $.gTireRecPostfix);
      return;
    }
    // @@ TODO test when connect IQ app started during activity -> save current tr in storage?
    $.gTireRecPostfix = trp;
    totalDistanceFrontTyre = getDistanceAsMeters("totalDistanceFrontTyre" + trp);
    maxDistanceFrontTyre = getDistanceAsMeters("maxDistanceFrontTyre" + trp);
    if (maxDistanceFrontTyre == 0.0f) {
      maxDistanceFrontTyre = 5000000.0f;
      setDistanceAsMeters("maxDistanceFrontTyre" + trp, maxDistanceFrontTyre);
    }
    totalDistanceBackTyre = getDistanceAsMeters("totalDistanceBackTyre" + trp);
    maxDistanceBackTyre = getDistanceAsMeters("maxDistanceBackTyre" + trp);
    if (maxDistanceBackTyre == 0.0f) {
      maxDistanceBackTyre = 5000000.0f;
      setDistanceAsMeters("maxDistanceBackTyre" + trp, maxDistanceBackTyre);
    }
    
    System.println("Tire distance loaded for: " + $.gTireRecPostfix);
  }

  function loadChainDistance(force as Boolean) as Void {
    var cr = $.getChainRecPostfix();
    if (!force and cr.equals($.gChainRecPostfix)) {
      System.println("Chain distance already loaded for: " + $.gChainRecPostfix);
      return;
    }
    $.gChainRecPostfix = cr;
    totalDistanceChain = getDistanceAsMeters("totalDistanceChain" + cr);
    maxDistanceChain = getDistanceAsMeters("maxDistanceChain" + cr);
    if (maxDistanceChain == 0.0f) {
      maxDistanceChain = 5000000.0f;
      setDistanceAsMeters("maxDistanceChain" + cr, maxDistanceChain);
    }    
    System.println("TChainire distance loaded for: " + $.gChainRecPostfix);
  }

  function triggerFrontBack() as Void {
    var trp = $.getTireRecPostfix();
    var switchFB = $.getStorageValue("switch_front_back", false) as Boolean;

    totalDistanceFrontTyre = getDistanceAsMeters("totalDistanceFrontTyre" + trp);
    maxDistanceFrontTyre = getDistanceAsMeters("maxDistanceFrontTyre" + trp);
    totalDistanceBackTyre = getDistanceAsMeters("totalDistanceBackTyre" + trp);
    maxDistanceBackTyre = getDistanceAsMeters("maxDistanceBackTyre" + trp);
    maxDistanceChain = getDistanceAsMeters("maxDistanceChain" + trp);

    var reset = $.getStorageValue("reset_front", false) as Boolean;
    if (reset) {
      totalDistanceFrontTyre = 0.0f;
      Storage.setValue("reset_front", false);
      if (!switchFB) {
        setDistanceAsMeters("totalDistanceFrontTyre" + trp, totalDistanceFrontTyre);
      }
    }

    reset = $.getStorageValue("reset_back", false) as Boolean;
    if (reset) {
      totalDistanceBackTyre = 0.0f;
      Storage.setValue("reset_back", false);
      if (!switchFB) {
        setDistanceAsMeters("totalDistanceBackTyre" + trp, totalDistanceFrontTyre);
      }
    }

    if (switchFB) {
      Storage.setValue("switch_front_back", false);
      var tmpBack = totalDistanceBackTyre;
      totalDistanceBackTyre = totalDistanceFrontTyre;
      totalDistanceFrontTyre = tmpBack;
      setDistanceAsMeters("totalDistanceFrontTyre" + trp, totalDistanceFrontTyre);
      setDistanceAsMeters("totalDistanceBackTyre" + trp, totalDistanceBackTyre);
    }

    var cr = $.getChainRecPostfix();
    reset = $.getStorageValue("reset_chain", false) as Boolean;
    if (reset) {
      totalDistanceChain = 0.0f;
      setDistanceAsMeters("totalDistanceChain" + cr, totalDistanceChain);
      Storage.setValue("reset_chain", false);
    }

    reset = $.getStorageValue("reset_track", false) as Boolean;
    if (reset) {
      if (totalDistanceTrack > 0.0f) {
        totalDistanceLastTrack = totalDistanceTrack;
        totalAscentLastTrack = totalAscentTrack;
        totalDescentLastTrack = totalDescentTrack;
      }
      totalDistanceTrack = 0.0f;
      totalAscentTrack = 0;
      totalDescentTrack = 0;
      saveTrack();
      Storage.setValue("reset_track", false);
    }
  }

  hidden function setDistanceAsMeters(key as String, distanceMeters as Float) as Void {
    try {
      
      Storage.setValue(key, distanceMeters);
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  hidden function getDistanceAsMeters(key as String) as Float {
    try {
      return $.getStorageValue(key, 0.0f) as Float;
    } catch (ex) {
      ex.printStackTrace();
      return 0.0f;
    }
  }

  hidden function handleDate() as Void {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

    if (currentYear == 0) {
      totalDistanceYear = 0.0f;
      currentYear = today.year;

      currentMonth = today.month as Number;
      totalDistanceLastMonth = 0.0f;
      totalDistanceMonth = 0.0f;

      currentWeek = iso_week_number(today.year, today.month as Number, today.day);
      totalDistanceLastWeek = 0.0f;
      totalDistanceWeek = 0.0f;

      totalDistanceLastTrack = 0.0f;
      totalDistanceTrack = 0.0f;

      totalDistanceLastRide = 0.0f;
      totalDistanceRide = 0.0f;

      save(true);
    }

    // year change
    if (currentYear != today.year) {
      totalDistanceLastYear = totalDistanceYear;
      lastYear = currentYear;

      totalDistanceYear = 0.0f;
      currentYear = today.year;
      saveYear();
    }

    // month change
    var month = today.month as Number;
    if (currentMonth != month) {
      currentMonth = month;
      totalDistanceLastMonth = totalDistanceMonth;
      totalDistanceMonth = 0.0f;
      saveMonth();
    }
    // week change
    var week = iso_week_number(today.year, today.month as Number, today.day);
    if (currentWeek != week) {
      currentWeek = week;
      totalDistanceLastWeek = totalDistanceWeek;
      totalDistanceWeek = 0.0f;
      saveWeek();
    }
  }

  hidden function handleRide() as Void {
    // ride started - via activity?
    // if (rideTimerState == Activity.TIMER_STATE_OFF and totalDistanceRide > 0) {
    //   if (totalDistanceRide > 500.0) {
    //     totalDistanceLastRide = totalDistanceRide;
    //   }
    //   totalDistanceRide = 0.0f; // same as elapseddistance
    //   System.println(
    //     Lang.format("handledate: rideStarted [$1$] ride [$2$] last ride [$3$] ", [
    //       rideStarted,
    //       totalDistanceRide,
    //       totalDistanceLastRide,
    //     ])
    //   );
    //   saveRide();
    // } else
    if (!rideStarted && rideTimerState == Activity.TIMER_STATE_ON) {
      // Only valid rides.. totalDistanceRide is current saved ride after activity

      if (totalDistanceRide > 500.0) {
        totalDistanceLastRide = totalDistanceRide;
        setDistanceAsMeters("totalDistanceLastRide", totalDistanceLastRide);
      }

      debugElapsedDistance = 0.0f;
      setDistanceAsMeters("debugElapsedDistance", debugElapsedDistance);
    
      totalDistanceRide = 0.0f; // same as elapseddistance
      rideStarted = true;
      System.println(
        Lang.format("handleRide: rideStarted [$1$] ride [$2$] last ride [$3$] ", [
          rideStarted,
          totalDistanceRide,
          totalDistanceLastRide,
        ])
      );
      saveRide();
    }
  }

  // hidden function setProperty(key as PropertyKeyType, value as PropertyValueType) as Void {
  //   Application.Properties.setValue(key, value);
  // }
}

class Total {
  public var title as String = "";
  public var abbreviated as String = "";
  public var distance as Float = 0.0f;
  public var distanceLast as Float = 0.0f;
}

function getTireRecPostfix() as String {
  switch ($.gTireRecording) {
    case TireRecDefault:
      return "";
    case TireRecProfile:
      var info = Activity.getProfileInfo();
      if (info == null) {
        return $.gActivityProfileId;
      }
      var arr = info.uniqueIdentifier;
      if (arr == null) {
        return $.gActivityProfileId;
      }
      $.gActivityProfileId = arr.toString();
      return $.gActivityProfileId;
    case TireRecSetA:
      return "A";
    case TireRecSetB:
      return "B";
    case TireRecSetC:
      return "C";
    case TireRecSetD:
      return "D";
  }
  return "";
}

function getChainRecPostfix() as String {
  switch ($.gChainRecording) {
    case ChainRecDefault:
      return "";
    case ChainRecProfile:
      var info = Activity.getProfileInfo();
      if (info == null) {
        return $.gActivityProfileId;
      }
      var arr = info.uniqueIdentifier;
      if (arr == null) {
        return $.gActivityProfileId;
      }
      $.gActivityProfileId = arr.toString();
      return $.gActivityProfileId;
    case ChainRecAsTire:
      return getTireRecPostfix();
    case ChainRecSetA:
      return "A";
    case ChainRecSetB:
      return "B";
    case ChainRecSetC:
      return "C";
    case ChainRecSetD:
      return "D";
  }
  return "";
}


function getProfileName(def as String) as String {
    var info = Activity.getProfileInfo();
    if (info == null) {
      return def;
    }
    if (info.name != null) {
      $.gActivityProfileName = info.name as String;
    }
    if ($.gActivityProfileName.length == 0) {
      return def;
    }
    return $.gActivityProfileName;    
}