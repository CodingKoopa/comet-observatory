// Disable about:config warning.
user_pref("browser.aboutConfig.showWarning", false);

// Enable custom CSS.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Disable form autofill.
user_pref("signon.autofillForms", false);

// Disable silly calculator feature.
user_pref("browser.urlbar.suggest.calculator", false);

// Disable Pocket.
user_pref("extensions.pocket.enabled", false);

// Disable full screen warning.
user_pref("full-screen-api.warning.timeout", 0);

// Enable VA-API decoding.
user_pref("media.ffmpeg.vaapi.enabled", true);

///  NATURAL SMOOTH SCROLLING V4 "SHARP" - AveYo, 2020-2022             preset     [default]
///  https://github.com/AveYo/fox
///  copy into firefox/librewolf profile as user.js, add to existing, or set in about:config
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 120); //NSS    [120]
user_pref("general.smoothScroll.msdPhysics.enabled", false); //NSS  [false]
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 1250); //NSS   [1250]
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 1000); //NSS   [1000]
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 12); //NSS     [12]
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "1.3"); //NSS    [1.3]
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 2000); //NSS   [2000]
user_pref("general.smoothScroll.currentVelocityWeighting", "0.25"); //NSS ["0.25"]
user_pref("general.smoothScroll.stopDecelerationWeighting", "0.4"); //NSS  ["0.4"]

/// adjust multiply factor for mousewheel - or set to false if scrolling is way too fast
user_pref("mousewheel.system_scroll_override.horizontal.factor", 200); //NSS    [200]
user_pref("mousewheel.system_scroll_override.vertical.factor", 200); //NSS    [200]
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", false); //NSS   [true]
user_pref("mousewheel.system_scroll_override.enabled", false); //NSS   [true]

/// adjust pixels at a time count for mousewheel - cant do more than a page at once if <100
user_pref("mousewheel.default.delta_multiplier_x", 100); //NSS    [100]
user_pref("mousewheel.default.delta_multiplier_y", 175); //NSS    [100]
user_pref("mousewheel.default.delta_multiplier_z", 100); //NSS    [100]

///  this preset will reset couple extra variables for consistency
user_pref("apz.allow_zooming", true); //NSS   [true]
user_pref("apz.force_disable_desktop_zooming_scrollbars", false); //NSS  [false]
user_pref("apz.paint_skipping.enabled", true); //NSS   [true]
user_pref("apz.windows.use_direct_manipulation", true); //NSS   [true]
user_pref("dom.event.wheel-deltaMode-lines.always-disabled", false); //NSS  [false]
user_pref("general.smoothScroll.durationToIntervalRatio", 200); //NSS    [200]
user_pref("general.smoothScroll.lines.durationMaxMS", 150); //NSS    [150]
user_pref("general.smoothScroll.lines.durationMinMS", 150); //NSS    [150]
user_pref("general.smoothScroll.other.durationMaxMS", 150); //NSS    [150]
user_pref("general.smoothScroll.other.durationMinMS", 150); //NSS    [150]
user_pref("general.smoothScroll.pages.durationMaxMS", 150); //NSS    [150]
user_pref("general.smoothScroll.pages.durationMinMS", 150); //NSS    [150]
user_pref("general.smoothScroll.pixels.durationMaxMS", 150); //NSS    [150]
user_pref("general.smoothScroll.pixels.durationMinMS", 150); //NSS    [150]
user_pref("general.smoothScroll.scrollbars.durationMaxMS", 150); //NSS    [150]
user_pref("general.smoothScroll.scrollbars.durationMinMS", 150); //NSS    [150]
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200); //NSS    [200]
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 50); //NSS     [50]
user_pref("layers.async-pan-zoom.enabled", true); //NSS   [true]
user_pref("layout.css.scroll-behavior.spring-constant", "250"); //NSS    [250]
user_pref("mousewheel.transaction.timeout", 1500); //NSS   [1500]
user_pref("mousewheel.acceleration.factor", 100); //NSS     [10]
user_pref("mousewheel.acceleration.start", -1); //NSS     [-1]
user_pref("mousewheel.min_line_scroll_amount", 5); //NSS      [5]
user_pref("toolkit.scrollbox.horizontalScrollDistance", 5); //NSS      [5]
user_pref("toolkit.scrollbox.verticalScrollDistance", 3); //NSS      [3]
