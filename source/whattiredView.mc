import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Math;

class whattiredView extends WatchUi.DataField {
  hidden var mDevSettings as System.DeviceSettings = System.getDeviceSettings();
  hidden var mFontText as Graphics.FontDefinition = Graphics.FONT_SMALL;
  hidden var mLabelWidth as Number = 10;
  hidden var mLabelWidthFocused as Number = 5;
  hidden var mLineHeight as Number = 10;
  hidden var mHeight as Number = 100;
  hidden var mWidth as Number = 100;

  hidden var mTotals as Totals;
  hidden var mFontFitted as Graphics.FontDefinition = Graphics.FONT_SMALL;
  hidden var mFonts as Array = [
    Graphics.FONT_XTINY,
    Graphics.FONT_TINY,
    Graphics.FONT_SYSTEM_SMALL,
    Graphics.FONT_SYSTEM_MEDIUM,
    Graphics.FONT_SYSTEM_LARGE,
    Graphics.FONT_NUMBER_MILD,
    Graphics.FONT_NUMBER_HOT,
    Graphics.FONT_NUMBER_THAI_HOT,
  ];

  var mNightMode as Boolean = false;
  var mColor as ColorType = Graphics.COLOR_BLACK;
  var mColorTextNoFocus as ColorType = Graphics.COLOR_DK_GRAY;
  var mColorValues as ColorType = Graphics.COLOR_BLACK;
  var mColorValuesPerc20 as ColorType = Graphics.COLOR_BLACK;
  var mColorValuesPerc100 as ColorType = Graphics.COLOR_WHITE;
  var mColorPerc100 as ColorType = Graphics.COLOR_RED;
  var mBackgroundColor as ColorType = Graphics.COLOR_WHITE;
  var mShowValues as Boolean = true;
  var mShowColors as Boolean = true;
  var mFocus as Types.EnumFocus = Types.FocusNothing;
  var mSmallField as Boolean = false;
  var mWideField as Boolean = false;
  var mTinyField as Boolean = false;
  var mShowFBCCircles as Boolean = false;
  var mShowAscDesc as Boolean = false;
  var mDataSaved as Boolean = true;
  var mPaused as Boolean = false;

  function initialize() {
    DataField.initialize();
    mTotals = getApp().mTotals;
    checkFeatures();
  }

  function checkFeatures() as Void {
    $.gCreateColors = Graphics has :createColor;
    try {
      $.gUseSetFillStroke = Graphics.Dc has :setStroke;
      if ($.gUseSetFillStroke) {
        $.gUseSetFillStroke = Graphics.Dc has :setFill;
      }
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  function onLayout(dc as Dc) as Void {
    mHeight = dc.getHeight();
    mWidth = dc.getWidth();
    mShowFBCCircles = false;

    mWideField = mWidth > 200;
    if (mHeight <= 100) {
      mFontText = Graphics.FONT_XTINY;
      mShowValues = $.gShowValuesSmallField;
      mShowColors = $.gShowColorsSmallField;
      mFocus = $.gShowFocusSmallField;
      mSmallField = true;
      mShowAscDesc = false;
    } else {
      mFontText = Graphics.FONT_SMALL;
      mShowValues = $.gShowValues;
      mShowColors = $.gShowColors;
      mFocus = Types.FocusNothing;
      mSmallField = false;
      mShowAscDesc = true;
    }
    mTinyField = mSmallField && !mWideField;

    mLabelWidth = dc.getTextWidthInPixels("Month", mFontText) + 2;
    mLabelWidthFocused = dc.getTextWidthInPixels("M", mFontText) + 2;
    mLineHeight = dc.getFontHeight(mFontText) - 1;

    var nrOfFields = $.gNrOfDefaultFields;
    // Minus line if small field and focus 1 item
    if (mSmallField && mFocus != Types.FocusNothing) {
      nrOfFields = nrOfFields - 1;
    }

    if (nrOfFields < 4) {
      if (mHeight <= 100) {
        mFontText = Graphics.FONT_SMALL;
      } else {
        mFontText = Graphics.FONT_MEDIUM;
      }
      mLabelWidth = dc.getTextWidthInPixels("Month", mFontText) + 2;
      mLabelWidthFocused = dc.getTextWidthInPixels("M", mFontText) + 2;
      mLineHeight = dc.getFontHeight(mFontText) - 1;
    }
    // Add extra line if front/back/chain enabled
    if (mTotals.HasFrontTyre() || mTotals.HasBackTyre() || mTotals.HasChain()) {
      nrOfFields = nrOfFields + 1;
      if (!mSmallField) {
        // Room for F B C Circles?
        var h = mLineHeight * (nrOfFields - 1);
        if (mHeight - h > 110) {
          mShowFBCCircles = true;
        }
      }
    }

    var totalHeight = nrOfFields * (mLineHeight + 1);
    if (totalHeight > mHeight) {
      var corr = Math.round((totalHeight - mHeight) / nrOfFields).toNumber() + 1;
      mLineHeight = mLineHeight - corr;
    }
  }

  // function onTimerPause() {
  //   mTotals.save(false);
  // }

  function onTimerReset() {
    saveTotals("onTimerReset");
  }

  function onTimerStop() {
    saveTotals("onTimerStop");
  }

  function compute(info as Activity.Info) as Void {
    mTotals.compute(info);

    // not always onTimerStop and onTimerReset is executed (??)
    if (info has :timerState) {
      if (info.timerState != null) {
        if (info.timerState == Activity.TIMER_STATE_STOPPED) {
          saveTotals("compute TIMER_STATE_STOPPED");
        } else if (info.timerState == Activity.TIMER_STATE_OFF) {
          saveTotals("compute TIMER_STATE_OFF");
        } else if (info.timerState == Activity.TIMER_STATE_ON) {
          mDataSaved = false;
        }
        mPaused = info.timerState == Activity.TIMER_STATE_PAUSED || info.timerState == Activity.TIMER_STATE_OFF;
      }
    }
  }

  function saveTotals(info as String) as Void {
    if (!mDataSaved) {
      System.println("saveTotals: " + info);
      mTotals.save(true);
      mDataSaved = true;
    }
  }

  function onUpdate(dc as Dc) as Void {
    if ($.gExitedMenu) {
      // fix for leaving menu, draw complete screen, large field
      dc.clearClip();
      $.gExitedMenu = false;
    }

    mBackgroundColor = getBackgroundColor();
    mNightMode = mBackgroundColor == Graphics.COLOR_BLACK;
    dc.setColor(mBackgroundColor, mBackgroundColor);
    dc.clear();

    if (mNightMode) {
      mColor = Graphics.COLOR_WHITE;
      mColorValues = Graphics.COLOR_WHITE;
      mColorValuesPerc20 = Graphics.COLOR_LT_GRAY;
      mColorTextNoFocus = Graphics.COLOR_LT_GRAY;
    } else {
      mColor = Graphics.COLOR_BLACK;
      mColorValues = Graphics.COLOR_BLACK;
      mColorValuesPerc20 = Graphics.COLOR_BLACK;
      mColorTextNoFocus = Graphics.COLOR_DK_GRAY;
    }

    drawData(dc, mFocus);
    if (mDataSaved) {
      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        dc.getWidth(),
        dc.getHeight() - dc.getFontHeight(Graphics.FONT_TINY),
        Graphics.FONT_TINY,
        "(s)",
        Graphics.TEXT_JUSTIFY_RIGHT
      );
    }
  }

  function drawData(dc as Dc, focus as Types.EnumFocus) as Void {
    var line = 0;
    var nothingHasFocus = focus == Types.FocusNothing;
    var info = "";
    if (mTotals.HasOdo() && focus != Types.FocusOdo) {
      DrawDistanceLine(
        dc,
        line,
        ["Odo", "O", ""],
        mTotals.GetTotalDistance(),
        mTotals.GetMaxDistance(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
    }
    if (mTotals.HasRide() && focus != Types.FocusRide) {
      DrawDistanceLine(
        dc,
        line,
        ["Ride", "R", ""],
        mTotals.GetTotalDistanceRide(),
        mTotals.GetTotalDistanceLastRide(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
    }
    if (mTotals.HasWeek() && focus != Types.FocusWeek) {
      if (mPaused) {
        info = mTotals.GetCurrentWeek().toString();
      }
      DrawDistanceLine(
        dc,
        line,
        ["Week", "W", info],
        mTotals.GetTotalDistanceWeek(),
        mTotals.GetTotalDistanceLastWeek(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
    }
    if (mTotals.HasMonth() && focus != Types.FocusMonth) {
      if (mPaused) {
        info = mTotals.GetCurrentMonth().toString();
      }
      DrawDistanceLine(
        dc,
        line,
        ["Month", "M", info],
        mTotals.GetTotalDistanceMonth(),
        mTotals.GetTotalDistanceLastMonth(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
    }
    if (mTotals.HasYear() && focus != Types.FocusYear) {
      if (mPaused) {
        info = mTotals.GetCurrentYear().toString();
      }
      DrawDistanceLine(
        dc,
        line,
        ["Year", "Y", info],
        mTotals.GetTotalDistanceYear(),
        mTotals.GetTotalDistanceLastYear(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
    }
    if (mTotals.HasTrack() && focus != Types.FocusTrack) {
      DrawDistanceLine(
        dc,
        line,
        ["Track", "T", ""],
        mTotals.GetTotalDistanceTrack(),
        mTotals.GetTotalDistanceLastTrack(),
        mShowValues,
        mShowColors,
        nothingHasFocus
      );
      line = line + 1;
      if (mShowAscDesc) {
        DrawAscentLine(
          dc,
          line,
          "-asc",
          "A",
          mTotals.GetTotalAscentTrack(),
          mTotals.GetTotalAscentLastTrack(),
          mShowValues,
          mShowColors,
          nothingHasFocus
        );
        line = line + 1;
        DrawAscentLine(
          dc,
          line,
          "-desc",
          "D",
          mTotals.GetTotalDescentTrack(),
          mTotals.GetTotalDescentLastTrack(),
          mShowValues,
          mShowColors,
          nothingHasFocus
        );
        line = line + 1;
      }
    }

    if (mShowFBCCircles) {
      //} && focus != Types.FocusFront && focus != Types.FocusBack) {
      DrawDistanceCirclesFrontBackChain(dc, line, mShowValues, mShowColors, nothingHasFocus);
    } else if (mTotals.HasFrontTyre() || mTotals.HasBackTyre() || mTotals.HasChain()) {
      DrawDistanceFrontBackTyreChain(dc, line, mShowValues, mShowColors, nothingHasFocus);
      line = line + 1;
    }
    // else if (
    //   focus != Types.FocusFront &&
    //   focus != Types.FocusBack &&
    //   mTotals.HasFrontTyre() &&
    //   mTotals.HasBackTyre()
    // ) {
    //   DrawDistanceFrontBackTyre(dc, line, mShowValues, mShowColors, nothingHasFocus);
    //   line = line + 1;
    // } else if (focus != Types.FocusFront && mTotals.HasFrontTyre()) {
    //   DrawDistanceLine(
    //     dc,
    //     line,
    //     "Front",
    //     "F",
    //     mTotals.GetTotalDistanceFrontTyre(),
    //     mTotals.GetMaxDistanceFrontTyre(),
    //     mShowValues,
    //     mShowColors,
    //     nothingHasFocus
    //   );
    //   line = line + 1;
    // } else if (focus != Types.FocusBack && mTotals.HasBackTyre()) {
    //   DrawDistanceLine(
    //     dc,
    //     line,
    //     "Back",
    //     "B",
    //     mTotals.GetTotalDistanceBackTyre(),
    //     mTotals.GetMaxDistanceBackTyre(),
    //     mShowValues,
    //     mShowColors,
    //     nothingHasFocus
    //   );
    //   line = line + 1;
    // }

    // @@ should be in background, alpha color
    // if (mTotals.IsCourseActive() && focus != Types.FocusCourse) {
    //   DrawDistanceLine(
    //     dc,
    //     line,
    //     "Crse",
    //     "C",
    //     mTotals.GetDistanceToDestination(),
    //     mTotals.GetElapsedDistanceToDestination(),
    //     mShowValues,
    //     mShowColors,
    //     nothingHasFocus
    //   );
    //   line = line + 1;
    // }

    switch (focus) {
      case Types.FocusOdo:
        drawDistanceCircle(dc, "Odo", mTotals.GetTotalDistance(), mTotals.GetMaxDistance(), true, true);
        break;
      case Types.FocusYear:
        drawDistanceCircle(dc, "Year", mTotals.GetTotalDistanceYear(), mTotals.GetTotalDistanceLastYear(), true, true);
        break;
      case Types.FocusMonth:
        drawDistanceCircle(
          dc,
          "Month",
          mTotals.GetTotalDistanceMonth(),
          mTotals.GetTotalDistanceLastMonth(),
          true,
          true
        );
        break;
      case Types.FocusWeek:
        drawDistanceCircle(dc, "Week", mTotals.GetTotalDistanceWeek(), mTotals.GetTotalDistanceLastWeek(), true, true);
        break;
      case Types.FocusRide:
        drawDistanceCircle(dc, "Ride", mTotals.GetTotalDistanceRide(), mTotals.GetTotalDistanceLastRide(), true, true);

        break;
      // case Types.FocusFront:
      //   drawDistanceCircle(
      //     dc,
      //     "Front",
      //     mTotals.GetTotalDistanceFrontTyre(),
      //     mTotals.GetMaxDistanceFrontTyre(),
      //     true,
      //     true
      //   );
      //   break;
      // case Types.FocusBack:
      //   drawDistanceCircle(
      //     dc,
      //     "Back",
      //     mTotals.GetTotalDistanceBackTyre(),
      //     mTotals.GetMaxDistanceBackTyre(),
      //     true,
      //     true
      //   );
      //   break;
      case Types.FocusTrack:
        drawDistanceCircle(
          dc,
          "Track",
          mTotals.GetTotalDistanceTrack(),
          mTotals.GetTotalDistanceLastTrack(),
          true,
          true
        );
        if (mWideField and mSmallField) {
          drawAscentDescent(dc, mTotals.GetTotalAscentTrack(), mTotals.GetTotalDescentTrack());
        }
        break;
      case Types.FocusCourse:
        if (mTotals.IsCourseActive()) {
          drawDistanceCircle(
            dc,
            "Course",
            mTotals.GetDistanceToDestination(),
            mTotals.GetElapsedDistanceToDestination(),
            true,
            true
          );
        } else {
          drawDistanceCircle(
            dc,
            "Ride",
            mTotals.GetTotalDistanceRide(),
            mTotals.GetTotalDistanceLastRide(),
            true,
            true
          );
        }
        break;
    }
  }

  function DrawDistanceLine(
    dc as Dc,
    line as Number,
    details as Array<String>, // [label, abbreviated, info]
    distanceInMeters as Float,
    lastDistanceInMeters as Float,
    showValues as Boolean,
    showColors as Boolean,
    nothingHasFocus as Boolean
  ) as Void {
    var x = 1;
    var y = mLineHeight * line;

    var label = details[0];
    var abbreviated = details[1];
    var info = details[2];

    if (nothingHasFocus) {
      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, label, Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidth;
    } else {
      dc.setColor(mColorTextNoFocus, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, abbreviated, Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidthFocused;
      showValues = false;
      showColors = true;
    }

    var units = getUnits(distanceInMeters);
    var value = getDistanceInMeterOrKm(distanceInMeters);
    var formattedValue = getNumberString(value, distanceInMeters);

    var perc = -1;
    if (lastDistanceInMeters > 0) {
      perc = percentageOf(distanceInMeters, lastDistanceInMeters);
      if (showColors) {
        drawPercentageLine(dc, x, y + 1, mWidth - x - 1, perc, mLineHeight - 1, percentageToColor(perc));
      }
    }
    if (showValues) {
      if (perc > -1 && perc <= 20) {
        dc.setColor(mColorValuesPerc20, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      }
      if (perc >= 130 && showColors) {
        dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
      }
      dc.drawText(x, y, mFontText, formattedValue + " " + units, Graphics.TEXT_JUSTIFY_LEFT);

      // draw perc last distance
      if (perc > -1) {
        formattedValue = "";
        if (perc >= 130 && showColors) {
          dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
        }
        if ($.gShowLastDistance) {
          units = getUnits(lastDistanceInMeters);
          value = getDistanceInMeterOrKm(lastDistanceInMeters);
          formattedValue = getNumberString(value, distanceInMeters) + " " + units;
        } else {
          formattedValue = perc.format("%d") + "%";
        }

        dc.drawText(mWidth - 1, y, mFontText, formattedValue, Graphics.TEXT_JUSTIFY_RIGHT);
      }
    } else if (info.length() > 0) {
      dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, info, Graphics.TEXT_JUSTIFY_LEFT);
    }
  }

  function DrawAscentLine(
    dc as Dc,
    line as Number,
    label as String,
    abbreviated as String,
    valueInMeters as Number,
    lastValueInMeters as Number,
    showValues as Boolean,
    showColors as Boolean,
    nothingHasFocus as Boolean
  ) as Void {
    var x = 1;
    var y = mLineHeight * line;

    if (nothingHasFocus) {
      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, label, Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidth;
    } else {
      dc.setColor(mColorTextNoFocus, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, abbreviated, Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidthFocused;
      showValues = false;
      showColors = true;
    }

    var units = getDistanceInMeterOrFeetUnits();
    var formattedValue = getDistanceInMeterOrFeet(valueInMeters).format("%d");

    var perc = -1;
    if (lastValueInMeters > 0) {
      perc = percentageOf(valueInMeters, lastValueInMeters);
      if (showColors) {
        drawPercentageLine(dc, x, y + 1, mWidth - x - 1, perc, mLineHeight - 1, percentageToColor(perc));
      }
    }
    if (showValues) {
      if (perc > -1 && perc <= 20) {
        dc.setColor(mColorValuesPerc20, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      }
      if (perc >= 130 && showColors) {
        dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
      }
      dc.drawText(x, y, mFontText, formattedValue + " " + units, Graphics.TEXT_JUSTIFY_LEFT);
      // draw perc right
      if (perc > -1) {
        if (perc >= 130 && showColors) {
          dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(mWidth - 1, y, mFontText, perc.format("%d") + "%", Graphics.TEXT_JUSTIFY_RIGHT);
      }
    }
  }

  function DrawDistanceFrontBackTyreChain(
    dc as Dc,
    line as Number,
    showValues as Boolean,
    showColors as Boolean,
    nothingHasFocus as Boolean
  ) as Void {
    var x = 1;
    var y = mLineHeight * line;
    var barWidth = mWidth / 3;
    var x2 = x + barWidth;
    var x3 = x2 + barWidth;

    var xStart = x;
    var x2Start = x2;
    var x3Start = x3;
    var barWidthStart = barWidth;

    if (nothingHasFocus && !mTinyField) {
      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, "Front", Graphics.TEXT_JUSTIFY_LEFT);
      dc.drawText(x2, y, mFontText, "Chain", Graphics.TEXT_JUSTIFY_LEFT);
      dc.drawText(x3, y, mFontText, "Back", Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidth;
      x2 = x2 + mLabelWidth;
      x3 = x3 + mLabelWidth;
      barWidth = barWidth - mLabelWidth;
    } else {
      dc.setColor(mColorTextNoFocus, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontText, "F", Graphics.TEXT_JUSTIFY_LEFT);
      dc.drawText(x2, y, mFontText, "C", Graphics.TEXT_JUSTIFY_LEFT);
      dc.drawText(x3, y, mFontText, "B", Graphics.TEXT_JUSTIFY_LEFT);
      x = x + mLabelWidthFocused;
      x2 = x2 + mLabelWidthFocused;
      x3 = x3 + mLabelWidthFocused;
      barWidth = barWidth - mLabelWidthFocused;
      showValues = false;
      showColors = true;
    }
    var meters_front = mTotals.GetTotalDistanceFrontTyre();
    var maxMeters_front = mTotals.GetMaxDistanceFrontTyre();

    var perc_front = -1;
    if (maxMeters_front > 0) {
      perc_front = percentageOf(meters_front, maxMeters_front);
      if (showColors) {
        drawPercentageLine(dc, x, y + 1, barWidth, perc_front, mLineHeight - 1, percentageToColor(perc_front)); // - x - 1
      }
    }
    if (showValues) {
      if (perc_front > -1 && perc_front <= 20) {
        dc.setColor(mColorValuesPerc20, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      }
      if (perc_front > -1) {
        if (perc_front >= 130 && showColors) {
          dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(x + barWidth - 1, y, mFontText, perc_front.format("%d") + "%", Graphics.TEXT_JUSTIFY_RIGHT);
      }
    }

    var meters_chain = mTotals.GetTotalDistanceChain();
    var maxMeters_chain = mTotals.GetMaxDistanceChain();

    var perc_chain = -1;
    if (maxMeters_chain > 0) {
      perc_chain = percentageOf(meters_chain, maxMeters_chain);
      if (showColors) {
        drawPercentageLine(dc, x2, y + 1, barWidth, perc_chain, mLineHeight - 1, percentageToColor(perc_chain)); // mWidth - x2 - 1
      }
    }

    if (showValues) {
      if (perc_chain > -1 && perc_chain <= 20) {
        dc.setColor(mColorValuesPerc20, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      }
      if (perc_chain > -1) {
        if (perc_chain >= 130 && showColors) {
          dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(x2 + barWidth - 1, y, mFontText, perc_chain.format("%d") + "%", Graphics.TEXT_JUSTIFY_RIGHT);
      }
    }

    var meters_back = mTotals.GetTotalDistanceBackTyre();
    var maxMeters_back = mTotals.GetMaxDistanceBackTyre();

    var perc_back = -1;
    if (maxMeters_back > 0) {
      perc_back = percentageOf(meters_back, maxMeters_back);
      if (showColors) {
        drawPercentageLine(dc, x3, y + 1, barWidth, perc_back, mLineHeight - 1, percentageToColor(perc_back)); // mWidth - x2 - 1
      }
    }

    if (showValues) {
      if (perc_back > -1 && perc_back <= 20) {
        dc.setColor(mColorValuesPerc20, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
      }
      if (perc_back > -1) {
        if (perc_back >= 130 && showColors) {
          dc.setColor(mColorValuesPerc100, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(x3 + barWidth - 1, y, mFontText, perc_back.format("%d") + "%", Graphics.TEXT_JUSTIFY_RIGHT);
      }
    }

    // the warning bars
    if (perc_front >= 100 || perc_chain >= 100 || perc_back >= 100) {
      var yWarning = y + mLineHeight + 1;
      var barHeight = mLineHeight;
      if (yWarning > dc.getHeight()) {
        yWarning = dc.getHeight();
        barHeight = yWarning - y - 1;
        if (barHeight <= 0) {
          barHeight = 1;
        }
      }
      if (perc_front >= 100) {
        dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(xStart, yWarning, barWidthStart, barHeight);
      }
      if (perc_chain >= 100) {
        dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x2Start, yWarning, barWidthStart, barHeight);
      }
      if (perc_back >= 100) {
        dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x3Start, yWarning, barWidthStart, barHeight);
      }
    }
  }

  function DrawDistanceCirclesFrontBackChain(
    dc as Dc,
    line as Number,
    showValues as Boolean,
    showColors as Boolean,
    nothingHasFocus as Boolean
  ) as Void {
    var mr = mHeight;
    if (mHeight > mWidth) {
      mr = mWidth;
    }
    var y = mLineHeight * line;
    var radius = (mr - y) / 3;
    var circleWidth = 10;
    y = y + radius;
    var x = mWidth / 6;
    var x2 = 3 * x;
    var x3 = 5 * x;

    radius = radius - circleWidth;
    var yLabel = y - radius;
    var yValue = y;

    var fontRecLabel = Graphics.FONT_TINY;
    var lineHeightRecLabel = dc.getFontHeight(fontRecLabel);
    var yRecLabel = yValue - mLineHeight / 2;
    // Space left to place label under?
    if (yValue + radius + 2 * lineHeightRecLabel < mHeight) {
      yRecLabel = yValue + radius + lineHeightRecLabel;
    } else {
      fontRecLabel = Graphics.FONT_XTINY;
      lineHeightRecLabel = dc.getFontHeight(fontRecLabel);
      if (yValue + radius + 2 * lineHeightRecLabel < mHeight) {
        yRecLabel = yValue + radius + lineHeightRecLabel;
      }
    }

    if (mTotals.HasFrontTyre()) {
      var meters_front = mTotals.GetTotalDistanceFrontTyre();
      var maxMeters_front = mTotals.GetMaxDistanceFrontTyre();
      var perc_front = -1;
      if (maxMeters_front > 0) {
        perc_front = percentageOf(meters_front, maxMeters_front);
        if (showColors) {
          drawPercentageCircleTarget(dc, x, y, radius, perc_front, circleWidth, mColorPerc100);
          dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
          dc.drawText(x, yLabel, mFontText, "Front", Graphics.TEXT_JUSTIFY_CENTER);

          var units_front = getUnits(meters_front);
          var value_front = getDistanceInMeterOrKm(meters_front);
          var formattedValue_front = value_front.format("%.0f"); // getNumberString(value_front, meters_front);
          dc.drawText(x, yValue, mFontText, formattedValue_front + " " + units_front, Graphics.TEXT_JUSTIFY_CENTER);
        }
      }
    }

    if (mTotals.HasChain()) {
      var meters_chain = mTotals.GetTotalDistanceChain();
      var maxMeters_chain = mTotals.GetMaxDistanceChain();

      var perc_chain = -1;
      if (maxMeters_chain > 0) {
        perc_chain = percentageOf(meters_chain, maxMeters_chain);
        if (showColors) {
          drawPercentageCircleTarget(dc, x2, y, radius, perc_chain, circleWidth, mColorPerc100);
          dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
          dc.drawText(x2, yLabel, mFontText, "Chain", Graphics.TEXT_JUSTIFY_CENTER);

          var units_chain = getUnits(meters_chain);
          var value_chain = getDistanceInMeterOrKm(meters_chain);
          var formattedValue_chain = value_chain.format("%.0f"); //getNumberString(value_chain, meters_chain);
          dc.drawText(x2, yValue, mFontText, formattedValue_chain + " " + units_chain, Graphics.TEXT_JUSTIFY_CENTER);
        }
      }
    }

    if (mTotals.HasBackTyre()) {
      var meters_back = mTotals.GetTotalDistanceBackTyre();
      var maxMeters_back = mTotals.GetMaxDistanceBackTyre();

      var perc_back = -1;
      if (maxMeters_back > 0) {
        perc_back = percentageOf(meters_back, maxMeters_back);
        if (showColors) {
          drawPercentageCircleTarget(dc, x3, y, radius, perc_back, circleWidth, mColorPerc100);
          dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
          dc.drawText(x3, yLabel, mFontText, "Back", Graphics.TEXT_JUSTIFY_CENTER);

          var units_back = getUnits(meters_back);
          var value_back = getDistanceInMeterOrKm(meters_back);
          var formattedValue_back = value_back.format("%.0f"); //getNumberString(value_back, meters_back);
          dc.drawText(x3, yValue, mFontText, formattedValue_back + " " + units_back, Graphics.TEXT_JUSTIFY_CENTER);
        }
      }
    }

    // @@ TODO tire / chain -> calc and cached
    var labelT = $.getTireRecordingSubLabel("tireRecording");
    if (labelT.equals("default")) {
      labelT = "";
    }
    var labelC = $.getChainRecordingSubLabel("chainRecording");
    if (labelC.equals("default") || labelC.equals("as tire")) {
      labelC = "";
    }
    var label = labelT;
    if (labelC.length() > 0) {
      label = label + "/" + labelC;
    }
    if (label.length() > 0) {
      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(mWidth / 2, yRecLabel, fontRecLabel, label, Graphics.TEXT_JUSTIFY_CENTER);
    }
    //"as tire"
  }

  function drawAscentDescent(dc as Dc, totalAscent as Number, totalDescent as Number) as Void {
    var font = Graphics.FONT_SMALL;
    var fh = dc.getFontHeight(font);
    var w = fh / 2;
    var y = mHeight - fh;

    dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);

    drawArrowUp(dc, 1, y, w, fh);
    dc.drawText(
      1 + w + 1,
      y,
      font,
      getDistanceInMeterOrFeet(totalAscent).format("%0d") + " " + getDistanceInMeterOrFeetUnits(),
      Graphics.TEXT_JUSTIFY_LEFT
    );

    drawArrowDown(dc, mWidth - w, y, w, fh);
    dc.drawText(
      mWidth - w - 1,
      y,
      font,
      getDistanceInMeterOrFeet(totalDescent).format("%0d") + " " + getDistanceInMeterOrFeetUnits(),
      Graphics.TEXT_JUSTIFY_RIGHT
    );
  }

  function drawArrowUp(dc as Dc, x as Number, y as Number, width as Number, height as Number) as Void {
    var xm = x + width / 2;
    var yd = height / 3;
    var ym = y + yd;

    dc.fillPolygon(
      [
        [xm, y],
        [x, ym],
        [x + width, ym],
      ] as Array<Point2D>
    );
    dc.fillRectangle(xm - 1, ym, 3, height - yd);
  }

  function drawArrowDown(dc as Dc, x as Number, y as Number, width as Number, height as Number) as Void {
    var xm = x + width / 2;
    var yd = height / 3;
    var ym = y + height - yd;

    dc.fillRectangle(xm - 1, y, 3, height - yd);
    dc.fillPolygon(
      [
        [x, ym],
        [x + width, ym],
        [xm, y + height],
      ] as Array<Point2D>
    );
  }

  function drawDistanceCircle(
    dc as Dc,
    label as String,
    distanceInMeters as Float,
    lastDistanceInMeters as Float,
    showValues as Boolean,
    showColors as Boolean
  ) as Void {
    var units = getUnits(distanceInMeters);
    var value = getDistanceInMeterOrKm(distanceInMeters);
    var formattedValue = value.format(getFormatString(distanceInMeters));
    var x = mWidth / 2;
    var y = mHeight / 2;
    var radius = x - 5;
    var circleWidth = 8;
    if (x > y) {
      radius = y - 5;
    }

    var perc = -1;
    if (lastDistanceInMeters > 0) {
      perc = percentageOf(distanceInMeters, lastDistanceInMeters);
      if (showColors) {
        drawPercentageCircleTarget(dc, x, y, radius, perc, circleWidth, null);
      }
    }

    if (showValues) {
      var mFontFitted = getMatchingFont(dc, mFonts, dc.getWidth(), formattedValue, mFonts.size() - 1) as FontType;

      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, mFontFitted, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, mHeight - mLineHeight - 2, mFontText, label + " in " + units, Graphics.TEXT_JUSTIFY_CENTER);
    }
  }

  hidden function getDistanceInMeterOrKm(distanceInMeters as Float) as Float {
    var value = distanceInMeters;
    if (value < 1000) {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        value = meterToFeet(value);
      }
    } else {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        value = kilometerToMile(value / 1000.0f);
      } else {
        value = value / 1000.0f;
      }
    }
    return value;
  }

  hidden function getDistanceInMeterOrFeet(distanceInMeters as Number) as Number {
    var value = distanceInMeters;
    if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
      value = meterToFeet(value).toNumber();
    }
    return value;
  }
  hidden function getDistanceInMeterOrFeetUnits() as String {
    if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
      return "f";
    } else {
      return "m";
    }
  }
  // @@ number only fonts doesnt contain spaces ..
  hidden function getNumberString(distanceInKmOrMiles as Float, distanceInMeters as Float) as String {
    var formatted = distanceInKmOrMiles.format(getFormatString(distanceInMeters));

    if (distanceInKmOrMiles < 1000 || formatted == "") {
      return formatted;
    }

    var wholesPart = formatted.toCharArray();
    var decimalSize = 3; //.00
    var chunkSize = 3;
    var chunks = [];
    var start = (wholesPart.size() - decimalSize) % chunkSize;
    if (start != 0) {
      chunks.add(StringUtil.charArrayToString(wholesPart.slice(0, start)));
    }
    for (var i = start; i < wholesPart.size(); i += chunkSize) {
      chunks.add(StringUtil.charArrayToString(wholesPart.slice(i, i + chunkSize)));
    }

    var numberString = "" as String;
    for (var j = 0; j < chunks.size(); j++) {
      if (numberString == "") {
        numberString = chunks[j] as String;
      } else if (j == chunks.size() - 1) {
        numberString = numberString + (chunks[j] as String);
      } else {
        numberString = numberString + " " + (chunks[j] as String);
      }
    }
    return numberString;
  }

  hidden function getUnits(distanceInMeters as Float) as String {
    // < 1 km -> feet or meters, above miles or kilometers
    if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
      if (distanceInMeters < 1000) {
        return "f";
      }
      return "mi";
    } else {
      if (distanceInMeters < 1000) {
        return "m";
      }
      return "km";
    }
  }

  hidden function getFormatString(distanceInMeters as Float) as String {
    if (distanceInMeters < 1000) {
      return "%.0f";
    }
    if (distanceInMeters < 10000) {
      return "%.2f";
    }
    return "%.2f";
  }
}
