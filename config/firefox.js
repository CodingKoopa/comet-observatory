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

// Configure smooth scroll.
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.lines.durationMinMS", 125);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.other.durationMaxMS", 125);
user_pref("general.smoothScroll.other.durationMinMS", 125);
user_pref("general.smoothScroll.pages.durationMaxMS", 125);
user_pref("general.smoothScroll.pages.durationMinMS", 125);

// Configure scroll amount.
user_pref("mousewheel.min_line_scroll_amount", 30);
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", true);
user_pref("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);
user_pref("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);
user_pref("toolkit.scrollbox.horizontalScrollDistance", 6);
user_pref("toolkit.scrollbox.verticalScrollDistance", 2);

user_pref("media.ffmpeg.vaapi.enabled", true);
