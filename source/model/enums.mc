import Toybox.Lang;
import Toybox.System;
module Types {
  enum EnumFocus {
    FocusNothing = 0,
    FocusOdo = 1,
    FocusYear = 2,
    FocusMonth = 3,
    FocusWeek = 4,
    FocusRide = 5,
    // FocusFront = 6,
    // FocusBack = 7,
    FocusCourse = 8,
    FocusTrack = 9,
  }

  enum EnumTrackRecording {
    TrackRecDisabled = 0,
    TrackRecAlways = 1,
    TrackRecWhenVisible = 2,
    TrackRecWhenFocus = 3,
  }

  enum EnumTireRecording {
    TireRecDefault = 0,
    TireRecProfile = 1,
    TireRecSetA = 2,
    TireRecSetB = 3,
    TireRecSetC = 4,
    TireRecSetD = 5
  }

  enum EnumChainRecording {
    ChainRecDefault = 0,
    ChainRecProfile = 1,
    ChainRecAsTire = 2,
    ChainRecSetA = 3,
    ChainRecSetB = 4,
    ChainRecSetC = 5,
    ChainRecSetD = 6
  }
}
