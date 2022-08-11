// Disable about:config warning.
user_pref("browser.aboutConfig.showWarning", false);

// Disable form autofill.
user_pref("signon.autofillForms", false);

// Disable silly calculator feature.
user_pref("browser.urlbar.suggest.calculator", false);

// Disable Pocket.
user_pref("extensions.pocket.enabled", false);

// Disable full screen warning.
user_pref("full-screen-api.warning.timeout", 0);

// Store the cache in RAM.
user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox");

// Set the correct frame rate.
user_pref("layout.frame_rate", 144);

// Enable VA-API decoding.
user_pref("media.ffmpeg.vaapi.enabled", true);
// Force enable WebRender. On the P500 it wasn't enabled by default.
user_pref("gfx.webrender.all", true);


////  NATURAL SMOOTH SCROLLING
////  https://pastebin.com/y5NvtjmD
// preset             info               [default]
// NSS     5        ACCEL MAX SPEED 1-20           [10]
user_pref("mousewheel.acceleration.factor", 5);
// NSS     4        accel after x ticks            [-1]
user_pref("mousewheel.acceleration.start", 4);
// NSS   100           reset previous             [100]
user_pref("mousewheel.default.delta_multiplier_x", 100);
// NSS   100           reset previous             [100]
// Empiraclly determined to make each "scroll" the same as Chrome.
user_pref("mousewheel.default.delta_multiplier_y", 77);
// NSS   100           reset previous             [100]
user_pref("mousewheel.default.delta_multiplier_z", 100);
// NSS  false       ignoring sys accel           [true]
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", false);
// NSS  1500           reset previous            [1500]
user_pref("mousewheel.transaction.timeout", 1500);
// NSS     0       lines vary with accel            [5]
user_pref("mousewheel.min_line_scroll_amount", 0);
// NSS     3       keyboard matches mwheel          [5]
user_pref("toolkit.scrollbox.horizontalScrollDistance", 3);
// NSS     3       keyboard matches mwheel          [3]
user_pref("toolkit.scrollbox.verticalScrollDistance", 3);
// NSS  true          smoothness boost           [true]
user_pref("layers.async-pan-zoom.enabled", true);
// NSS  true          keyboard fix I            [false]
user_pref("apz.force_disable_desktop_zooming_scrollbars", true);
// NSS  false         keyboard fix II v85        [true]
user_pref("apz.paint_skipping.enabled", false);
// NSS  true       report wheel in pixels       [false]
user_pref("dom.event.wheel-deltaMode-lines.always-disabled", true);
// NSS  "300"      css mimics gecko scroll        [250]
user_pref("layout.css.scroll-behavior.spring-constant", "300.0");
// NSS   100      lame pref wreks settings        [100]
user_pref("general.smoothScroll.mouseWheel.migrationPercent", 100);
// NSS  false        no stutering fling         [false]
// I like this to be true so that we stop scrolling as soon as we let go.
user_pref("general.smoothScroll.msdPhysics.enabled", true);
// NSS  "0.0"          reduce stutter            [0.25]
user_pref("general.smoothScroll.currentVelocityWeighting", "0.0");
// NSS   400           reduce stutter             [200]
user_pref("general.smoothScroll.durationToIntervalRatio", 400);
// NSS  "0.0"          reduce stutter             [0.4]
user_pref("general.smoothScroll.stopDecelerationWeighting", "0.0");
// NSS   300          arrows smoothing            [150]
user_pref("general.smoothScroll.lines.durationMaxMS", 300);
// NSS   300          arrows smoothing            [150]
user_pref("general.smoothScroll.lines.durationMinMS", 300);
// NSS   300          mwheel smoothing            [200]
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 300);
// NSS   300          mwheel smoothing             [50]
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 300);
// NSS   150          home-end smoothing          [150]
user_pref("general.smoothScroll.other.durationMaxMS", 150);
// NSS   150          home-end smoothing          [150]
user_pref("general.smoothScroll.other.durationMinMS", 150);
// NSS   200         pgup-pgdn smoothing          [150]
user_pref("general.smoothScroll.pages.durationMaxMS", 200);
// NSS   200         pgup-pgdn smoothing          [150]
user_pref("general.smoothScroll.pages.durationMinMS", 200);
// NSS   300           pixel smoothing            [150]
user_pref("general.smoothScroll.pixels.durationMaxMS", 300);
// NSS   300           pixel smoothing            [150]
user_pref("general.smoothScroll.pixels.durationMinMS", 300);
// NSS   500         scrollbar smoothing          [150]
user_pref("general.smoothScroll.scrollbars.durationMaxMS", 500);
// NSS   500         scrollbar smoothing          [150]
user_pref("general.smoothScroll.scrollbars.durationMinMS", 500);
