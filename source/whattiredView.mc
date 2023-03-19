import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Math;

class whattiredView extends WatchUi.DataField {
    hidden var mDevSettings as System.DeviceSettings = System.getDeviceSettings();
    hidden var mFontText as Graphics.FontDefinition = Graphics.FONT_SMALL;    
    hidden var mFontText_Large as Graphics.FontDefinition = Graphics.FONT_LARGE;    
    hidden var mLabelWidth as Number = 10;
    hidden var mLabelWidthFocused as Number = 5;
    hidden var mLineHeight as Number = 10;
    hidden var mLineHeight_Large as Number = 10;
    hidden var mHeight as Number = 100;
    hidden var mWidth as Number = 100;

    hidden var mTotals as Totals;

    var mNightMode as Boolean = false;
    var mColor as ColorType = Graphics.COLOR_BLACK;
    var mColorValues as ColorType = Graphics.COLOR_BLACK;
    var mColorValues20 as ColorType = Graphics.COLOR_BLACK;
    var mColorPerc100 as ColorType = Graphics.COLOR_WHITE;
    var mBackgroundColor as ColorType = Graphics.COLOR_WHITE;
    var mShowValues as Boolean = true;
    var mShowColors as Boolean = true;

    function initialize() {
        DataField.initialize();
        mTotals = getApp().mTotals;        
    }
   
    function onLayout(dc as Dc) as Void {
        mHeight = dc.getHeight();
        mWidth = dc.getWidth();
        if (mHeight < 92) {
          mFontText = Graphics.FONT_XTINY;
          mShowValues = $.gShowValuesSmallField;
          mShowColors = $.gShowColorsSmallField;
        } else {
          mFontText = Graphics.FONT_SMALL;
          mShowValues = $.gShowValues;
          mShowColors = $.gShowColors;
        }

        mLabelWidth = dc.getTextWidthInPixels("Month", mFontText) + 5;
        mLabelWidthFocused = dc.getTextWidthInPixels("M", mFontText) + 5;
        mLineHeight = dc.getFontHeight(mFontText);
        mLineHeight_Large = dc.getFontHeight(mFontText_Large);

        var nrOfFields = 5.0f;
        var totalHeight = nrOfFields * mLineHeight;
        if (totalHeight > mHeight) {
          var corr = Math.round((totalHeight - mHeight) / nrOfFields).toNumber() + 1;
          mLineHeight = mLineHeight - corr;
        }        
    }
   
    function onTimerReset() {
      mTotals.save();      
    }        

    function compute(info as Activity.Info) as Void {
        mTotals.compute(info);        
    }

    function onUpdate(dc as Dc) as Void {

        mBackgroundColor = getBackgroundColor();
        mNightMode = (mBackgroundColor == Graphics.COLOR_BLACK);
        dc.setColor(mBackgroundColor, mBackgroundColor);    
        dc.clear();

        if (mNightMode) {      
            mColor = Graphics.COLOR_WHITE;
            mColorValues = Graphics.COLOR_WHITE;      
            mColorValues20 = Graphics.COLOR_LT_GRAY;      
        } else {
            mColor = Graphics.COLOR_BLACK;
            mColorValues = Graphics.COLOR_BLACK;
            mColorValues20 = Graphics.COLOR_BLACK;
        }
    
        dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);
      
        var focus = $.gShowFocusSmallField;       
        drawData(dc, focus);

        
        // @@ will be front/back tire circle - set max km per front/back ex. 3000km
        // if ($.gShowCurrentProfile) {
        //   DrawDistanceLine(dc, 5, mTotals.GetCurrentProfile() , mTotals.GetTotalDistanceYear(), mTotals.GetTotalDistanceLastYear(), showValues, showColors);        
        // }
    }

    function drawData(dc as Dc, focus as Types.EnumFocus) as Void {
      var line = 0;      
      var noFocus = focus == Types.FocusNothing;

      if (focus != Types.FocusOdo) {
        DrawDistanceLine(dc, line, "Odo", "O", mTotals.GetTotalDistance(), 0.0f, true, true, noFocus);
        line = line + 1;
      }
      if (focus != Types.FocusRide) {
        DrawDistanceLine(dc, line, "Ride", "R", mTotals.GetTotalDistanceRide(), mTotals.GetTotalDistanceLastRide(), mShowValues, mShowColors, noFocus);
        line = line + 1;
      }
      if (focus != Types.FocusWeek) {
        DrawDistanceLine(dc, line, "Week", "W", mTotals.GetTotalDistanceWeek(), mTotals.GetTotalDistanceLastWeek(), mShowValues, mShowColors, noFocus);
        line = line + 1;
      }
      if (focus != Types.FocusMonth) {
        DrawDistanceLine(dc, line, "Month", "M", mTotals.GetTotalDistanceMonth(), mTotals.GetTotalDistanceLastMonth(), mShowValues, mShowColors, noFocus);
        line = line + 1;
      }
      if (focus != Types.FocusYear) {
        DrawDistanceLine(dc, line, "Year", "Y", mTotals.GetTotalDistanceYear(), mTotals.GetTotalDistanceLastYear(), mShowValues, mShowColors, noFocus);  
        line = line + 1;
      }

      // @@ TEST
      if (mTotals.HasFrontTyreTrigger()) {
        DrawDistanceLine(dc, line, "Front", "F", mTotals.GetTotalDistanceFrontTyre(), mTotals.GetMaxDistanceFrontTyre(), mShowValues, mShowColors, noFocus);  
        line = line + 1;
      }
      if (mTotals.HasBackTyreTrigger()) {
        DrawDistanceLine(dc, line, "Back", "B", mTotals.GetTotalDistanceBackTyre(), mTotals.GetMaxDistanceBackTyre(), mShowValues, mShowColors, noFocus);  
        line = line + 1;
      }
        // if focus, then example Ride = 'R' and focus 'Odo' in first line,
        // draw circle, then rest of items as bar with first char

      // Draw the front / back tire circles 
      
      // Draw the focused on top with white border, inside perc
      switch(focus) {
        case Types.FocusOdo:
          drawDistanceCircle(dc, "Odo", mTotals.GetTotalDistance(), 0.0f, true, true);
          break;
        case Types.FocusYear:
          drawDistanceCircle(dc, "Year", mTotals.GetTotalDistanceYear(), mTotals.GetTotalDistanceLastYear(), true, true);
          break;
        case Types.FocusMonth:
          drawDistanceCircle(dc, "Month", mTotals.GetTotalDistanceMonth(), mTotals.GetTotalDistanceLastMonth(), true, true);
          break;
        case Types.FocusWeek:
          drawDistanceCircle(dc, "Week", mTotals.GetTotalDistanceWeek(), mTotals.GetTotalDistanceLastWeek(), true, true);
          break;
        case Types.FocusRide:
          drawDistanceCircle(dc, "Ride", mTotals.GetTotalDistanceRide(), mTotals.GetTotalDistanceLastRide(), true, true);
          break;        
      }      
    }

    function DrawDistanceLine(dc as Dc, line as Number, label as String, abbreviated as String,  distanceInMeters as Float, 
      lastDistanceInMeters as Float, showValues as Boolean, showColors as Boolean, noFocus as Boolean ) as Void {
        var x = 1;
        var y = 1 + (mLineHeight * line);
        
        dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);        
        if (noFocus) {
          dc.drawText(x, y, mFontText, label, Graphics.TEXT_JUSTIFY_LEFT);
          x = x + mLabelWidth;
        } else {
          dc.drawText(x, y, mFontText, abbreviated, Graphics.TEXT_JUSTIFY_LEFT);
          x = x + mLabelWidthFocused;
        }

        var units = getUnits(distanceInMeters);
        var value = getDistanceInMeterOrKm(distanceInMeters);
        var formattedValue = getNumberString(value, distanceInMeters);
       
        var perc = -1;
        if (lastDistanceInMeters > 0) {
          perc = percentageOf(distanceInMeters, lastDistanceInMeters);
          if (showColors) {
            drawPercentageLine(dc, x, y + 1, mWidth - x - 1, perc, mLineHeight - 2, percentageToColor(perc));
          }
        }
        if (perc > -1 && perc <= 20) {
          dc.setColor(mColorValues20, Graphics.COLOR_TRANSPARENT);
        } else {
          dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
        }
        if (showValues) {
          if (perc >= 130 && showColors) { dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT); }
          dc.drawText(x, y, mFontText, formattedValue + " " + units, Graphics.TEXT_JUSTIFY_LEFT);     
        }
        // draw perc right   
        if (perc > -1) {
          if (perc >= 130 && showColors) { dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT); }
          dc.drawText(mWidth -1, y, mFontText, perc.format("%d") + "%", Graphics.TEXT_JUSTIFY_RIGHT);     
        }
    }

    function drawDistanceCircle(dc as Dc, label as String, distanceInMeters as Float, lastDistanceInMeters as Float, showValues as Boolean, showColors as Boolean) as Void {        
        var units = getUnits(distanceInMeters);
        var value = getDistanceInMeterOrKm(distanceInMeters);
        var formattedValue = getNumberString(value, distanceInMeters);
       
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        var radius = x - 5;
        if (x > y) { radius = y - 5; }

        var perc = -1;
        if (lastDistanceInMeters > 0) {
          perc = percentageOf(distanceInMeters, lastDistanceInMeters);
          if (showColors) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawCircle(x, y, radius);
            
            dc.setColor(percentageToColor(perc), Graphics.COLOR_TRANSPARENT);
            drawPercentageCircle(dc, x, y, radius, perc, 4);
          }
        }

        if (showValues) {
          if (perc > -1 && perc <= 20) {
            dc.setColor(mColorValues20, Graphics.COLOR_TRANSPARENT);
          } else {
            dc.setColor(mColorValues, Graphics.COLOR_TRANSPARENT);
          }
          
          dc.setColor(mColor, Graphics.COLOR_TRANSPARENT);        
          if (perc >= 130 && showColors) { dc.setColor(mColorPerc100, Graphics.COLOR_TRANSPARENT); }
          dc.drawText(x, y, mFontText_Large, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);     

          dc.drawText(x, y + mLineHeight_Large, mFontText_Large, units, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);     
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

    hidden function getNumberString(distanceInKmOrMiles as Float, distanceInMeters as Float) as String {
      var formatted = distanceInKmOrMiles.format(getFormatString(distanceInMeters));     

      if ((distanceInKmOrMiles < 1000) || (formatted == "")) { return formatted; }

      var wholesPart = formatted.toCharArray();
      var decimalSize = 3; //.00
      var chunkSize = 3;
      var chunks = [];
      var start = (wholesPart.size() - decimalSize) % chunkSize;
      if(start != 0) {
          chunks.add(StringUtil.charArrayToString(wholesPart.slice(0, start)));
      }
      for(var i = start; i < wholesPart.size(); i+= chunkSize) {
          chunks.add(StringUtil.charArrayToString(wholesPart.slice(i, i + chunkSize)));
      }
      
      var numberString = "" as String;
      for (var j = 0; j < chunks.size(); j++) {
        if (numberString == "") {
          numberString = chunks[j] as String;
        } else if (j == chunks.size() - 1) {
          numberString = numberString + chunks[j] as String;
        } else {
          numberString = numberString + " " + chunks[j] as String;
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
// font / 
// color / day/night
// odo # 
// ride perc
// wk # + perc
// month string # + perc
// year  # + perc

// display km / miles
// colors perc