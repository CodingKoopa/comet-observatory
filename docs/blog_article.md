## Disillusionment with the Linux Desktop Environment

### A retrospective

I've used a pretty decent array of the major Desktop Environments (DEs) that are available for use. I used Ubuntu casually, back when Canonical shipped the Unity desktop, to which I can't really speak on in any technical capacity. My experience with the rest of the DEs I have tried is more nuanced, yet there is still some difficulty in speaking on them because it's been at most 2-3 years since I've tried some of tiem, which in Linux time can bring a lot of changes, depending on the pace of development.

The story of this section begins and ends with me deriving curiosity and inspiration from other people's Linux desktops. When I was planning on installing Arch Linux, I was somewhat on the market for a DE - although I definitely didn't know this term at the time. I saw a tweet featuring the Budgie desktop by Solus, and I thought that it looked pretty, so I asked the author what they were using. And then I used it.

Frankly, the details are a little hazy; it's within the realm of possibilities that this heavily influenced my distro choice too.

Budgie isn't bad; it was just really limited in customization when I used it, and I imagine that this is still a part of the general design direction. In spite of this, I'm not aware of it being especially light on resources, but the simple UI still is attracting; I might use this if I ever needed a ChromeOS-like interface on a device that has enough processing power. I moved on from Budgie when I really needed more control over my desktop.


At this point, I gave both LXDE and XFCE a shot. LXDE, as a sort of de-facto light graphical environment, is generally my choice for my Raspberry Pi if I am running any X programs (these days, it is usually running headless though). On the desktop, it feels a little too barebones for my liking, but I see some people get along with it just fine. It having been a few years, I am curious to see how things have progressed. One development, LXQt, is an intruiging project that appears to be making decent headway. This, combined with perhaps some prettier theming defaults, make me excited to use it again whenever I do need a light setup.

XFCE fared quite well - it strikes a healthy balance between being lightweight, and being configurable. I generally find it comfortable to use, and would easily recommend it for low end systems that may not be so fond of GNOME and friends. This was the one DE that I customized to my heart's content, and I think a lot of the setup aged pretty well.

<insert>

Eventually after this, I switched to GNOME for reasons I don't quite remember. It may not have been out of dissatisfaction with XFCE as much as curiosity and interest in GNOME. By this point, you might be a little confused as to why KDE has had no representation. The answer to that is... I couldn't. At one point, I did *try* running KDE on my laptop, but it was unusably slow and laggy. Considering that it was able to run GNOME just fine, I do wonder if this was some sort of configuration error. I tried everything I could, but KDE on my laptop just wasn't workable.

GNOME, curiously, does not have minimize or maximize buttons in its window decorations by default. It's very easy to change this - in part due to the volume of people coming from other window managers, who Don't Like Change. One of the posts I read, though, explained that the *reason* behind this change was that workflows that involve often maximizing and minimizing windows aren't as efficient as those which exploit a virtual desktop.

So, GNOME forced me to learn how to use virtual desktops. And it was perhaps the biggest workflow improvement I've ever experienced.

Just about every Linux DE *supports* virtual desktops, but GNOME is, to my knowledge, unique in encouraging this workflow as much as it does. And I'm glad for that - so much so, that, even in other environments, I will remove those two buttons from the window directions because, it's true that in a workspace based workflow, you really don't use them. In the off chance that they are needed, I have keyboard shortcuts to fall back to, but these occurrences are rare.

I'm not sure if I can be so positive about the rest of the GNOME experience. It's no secret that many are not fans of the design paradigm they apply with putting more than one line of information in their title bars, and, more controversially, putting the application functionality in hamburger menus. Indeed, I don't think this is is the best way of presenting information and controls to desktop users, although that in particular bothered me all that much. The only program I regularly used that used these titlebar controls is probably Nautilus, and perhaps the terminal software. GNOME isn't the worst thing in the world, but its subtle design issues do add up. I was mildly disappointed when Ubuntu opted for GNOME as their new default DE as it appears that, with all due respect, the GNOME developers are keeping most of these choices in place.

On paper, KDE Plasma checked off a lot of boxes of what I wanted in an environment. When I got a desktop PC, and could use that rather than my laptop, I tried it out, and, it *fulfilled* all those boxes. Breeze is a nice looking color scheme, and the Plasma UI has always had more than enough customization options. I've used Plasma for longer than any of the other desktop environments - in fact, my memories of using GNOME coincide with what feels like a different part of my life. While this seems awfully unfair to the other DEs, who haven't had a shot here as their 2021 selves, Plasma hasn't changed fundamentally while I used it. I started using Plasma well after the Plasma 5 release, as KDE was well making headway on restoring their reputation of being bloated.

One of Plasma's most distinguishing "features", though, is spearheaded by one person - [Nate "PointiestStick" Graham](https://pointieststick.com/). Graham runs the "This week in KDE" blog series, reporting on KDE bug fixes, features, and updates on a weekly basis. This has been a wonderful way to stay on top of what is coming to Plasma, and is one of the main channels of communication between Plasma developers, and Plasma users.

### Issues with KDE

To say that the aim of the KDE project is daunting would be an understatement. There is an incomprehensible amount of variables for developers to consider, including how different parts of the desktop stack interact with each other, configurations shipped by different distributions, and the sheer amount of code they maintain under the KDE umbrella. This isn't an issue unique to KDE; I see the Arch Linux package maintainers work hard to provide a coherent end-user experience, and similar things can be said about the GNOME developers (yes, be nice).

KDE has come a long way. I am spoiled and only started using KDE when it was *already* pretty good, well into the Breeze era. Yet I've still seen it grow a fair bit in my time using it. But it's not where it should be, still.

I often think about how much of a well-oiled machine kernel development is, in contrast to how much more seemingly strapped for resources the desktop scene is. Compared to the kernel's strict standards for quality, the desktop seems to struggle to deliver an excellent experience. In some departments, we are now catching up to what *should* be expected from a modern desktop, but as a whole it feels like we are lagging behind.

In 2017, [probono](https://github.com/probonopd) wrote the first entry of his series ["Make. It. Simple. Linux Desktop Usability"](https://medium.com/@probonopd/make-it-simple-linux-desktop-usability-part-1-5fa0fb369b42). This series is a brilliant dive into many of the issues that the Linux desktop have, which I won't be repeating here. In addition to identifying inconsistencies in the user experience, he reviews how many of these conceptual challenges have been long but solved by older yet more intuitive user interfaces.

My frustration with the Linux desktop is less profound; the issues I have with KDE are more surface level pains that I don't see going away that soon.

#### Inconsistent Experiences

Due to the aforementioned complexity of the KDE desktop, it has a fair share of bugs and inconsistencies. Bugs and inconsistencies which *are* being worked on, but they are hard to ignore. Here are some examples off of the top of my head:
- On my laptop, the battery indicator sometimes just doesn't show up, with no indication of why. I believe this occurs after sleep.
- I recently got a window stuck in a "being dragged state", and no inputs I gave could allow me to interact with any programs.
- Upon a recent reinstallation, any custom shortcuts I added didn't seem to work, as the deleted default shortcuts would always be re-added.
- During that same reinstallation, I couldn't get Plasma to properly map my compose key, despite it being seemingly setup properly in the Plasma settings. I ended up adding `setxkbmap` to my startup sctipts, and eventually created an Xorg config snippet.
- My [System Load](System Load.md) widget randomly [stopped working](https://bugs.kde.org/show_bug.cgi?id=415500).
- The Plasma System Monitor has frequent crashes, displays empty rows, unwisely manages column sizes, and doesn't seem to remember newly added columns.
- When logging out, the top part application menu flickers as the animation of it being pulled down is replayed. This may not be the fault of Plasma as much as my nonstandard setup without a desktop manager.

I'm not pessimistic of the future of KDE Plasma, but I am overwhelmed by these bad experiences. The desktop stack is *complicated*, and it can make these issues very difficult to troubleshoot at times. I don't hate KDE Plasma; I would still recommend it, but I want off of this wild ride. I want my desktop to be simpler.

#### Configuration Pains

This section is dedicated to a more specific frustration I have with KDE: The configuration files are not conducive to being edited or synced with a cloud. As we'll see, this is issue is not exclusive to KDE software, but manifests itself here nonetheless, and is worth discussing.

##### A case study on Plasma Shell

There is much discourse on the internet about the difficulties of configuring KDE Plasma. The developers have been cognizant of this though, and I am satisfied with the current state of KDE System Settings. The issues I've are is not with the tailored GUI experience, but with KDE settings being stored in a way that hinders syncing and non-GUI readability.

Plasma's user configuration state is just about all in the `~/.config` directory, in `rc` files. The names of the RC files is often undocumented, resulting in you having to take a best guess as to which `rc` file is the right one.

So, let's say I want to take my Plasma panel, and copy it to another system. I looked around my `~/.config` and located a `plasmashellrc` file. This is an excerpt of some of its contents:
```
[ActionsWidget]
ColumnState=AAAA/wAAAAAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdAAAAACAQAAAQAAAAAAAAAAAAAAAGT/////AAAAgQAAAAAAAAACAAAA+gAAAAEAAAAAAAAA1gAAAAEAAAAAAAAD6AAAAABk

[KFileDialog Settings]
Recent Files[$e]=<redacted for this article>
Recent URLs[$e]=<redacted for this article>
iconViewIconSize=43

[PlasmaViews][Panel 25][Defaults]
thickness=44

[PlasmaViews][Panel 25][Horizontal1920]
thickness=44
```
We have:
- An encoded `ColumnState` key. Due to the encoding, this is useless to a human.
- Keys for recent files and URLs. This isn't so much a configuration value as it is a "user data" value, or perhaps a "cached" value (see `~/.local/share` and `~/.cache` respectively).
- Some (undocumented) configuration values. There's not much a human with a text editor can do with this, still, but it *is* a configuration value and I can vaguely tell what is going on.

There is a poor separation between proper configuration values, and state values that are aren't so much settings as they are properties that the program sets at its own will. I've seen this with other Qt programs (and have done this myself), where it's easiest to take persistent state values like window geometry, and group it with the rest of the configuration values. This becomes problematic if you would like to sync your Plasma configuration files with the cloud. You will notice that, even though you haven't changed any settings, new uploads will be triggered periodically to reflect the new state.

##### Fixing this issue

At play here are two separate issues, the first one being the poor separation of configuration of state. This issue isn't such a big deal, and would be a relatively small thing to fix for a program. At the scale of a project like KDE, there are magnitudes more configuration files to worry about, and greater care must be given to migration paths for existing installations.

The other issue here, though, is one which systematically applies to nearly every configurable program, and has a much less clear path forward.

The vast majority of desktop programs either provide a GUI configuration through a settings dialogue, or a "CLI configuration", that is, configuration provided with an officially supported text-based configuration file. For programs which fall into the former category, they usually store their configurations using:
- [INI](https://en.wikipedia.org/wiki/INI_file). Despite lacking a specification, INI is prevalent on both Windows and Linux. There is usually hope for programs that use this format, as they are very much readable and editable so long as they don't store unrelated runtime state in the file.
- The [Registry](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry), if on Windows. This is fair enough, I can export and import registry keys.
- Abstractions such as [QSettings](https://doc.qt.io/qt-5/qsettings.html) that pick something like one of the above two options.
- [JSON](https://www.json.org/). This one is a newcomer, relatively speaking, and one which I have no complaints about, except for perhaps when implementations don't support comments.
- Bespoke formats. This is the worst case scenario for our purposes, as these are generally not possible to read or edit, and are unpleasant to sync.

The worst I've seen is MEGASync, which [stores the values to its keys using Base64 encoding](https://stackoverflow.com/a/38426429). The vast majority of programs fall into the same boat of KDE, using INI configurations that you *can* edit and sync, but often discourage you from doing so.

The program that handles this better than any other, to me, is [Visual Studio Code](https://code.visualstudio.com/). VS Code provides a feature-complete full GUI configuration, while also providing still first-class support for editing its JSON based configuration files. This provides usability for users who don't want to use the configuration files, while making it a joy for power users to tune the program to their liking, and share their configurations.

VS Code's system should be considered the gold standard for configurable desktop programs. It provides an intuitive interface without sacrificing the ability to manually manage the underlying configuration. I don't think it's realistic to want more programs to adopt this; I can see that there are challenges in serializing the configuration in a way that's editable to both the settings dialog and the human. For what I want out of my desktop, though, it is something I hold against DEs in their current states.

##### Honorable mentions

[This Plasma applet](https://store.kde.org/p/1298955/) was created provide an alternative approach to migrating KDE setups, integrated with the desktop. This seems like a useful utility that I wish I knew about sooner, but I don't think this is the solution I'm looking for. The ideal solution is one which allows the user to pragmatically make revisions to their configuration files, involving an amount of precision that an import/export mechanism doesn't provide.

You may also [edit the system-level Plasma configuration](https://wiki.archlinux.org/title/KDE#Configure_Plasma_for_all_users), but this seems to be an undocumented and unsupported process.

### Conclusion

I still want to love KDE, and I will continue to follow its journey in leading the Linux desktop forward. I am questioning whether it is right for me, though. I am now in the market for a lighter desktop stack, something that is less complicated, and easier to manage. For a month, now, I have been exclusively using dwm on my desktop machine, while still using KDE Plasma on my laptop until I am ready to transition that machine. My dwm desktop is about as simple as can be, I don't even have a bar because I wanted to finish writing this article before moving forward with this. The fact that I have functioned with such a minimalist setup, has proven to me viability of moving away from Plasma. In any case, I am excited to customize my new desktop, and will certainly write more about it.

Don't be mistaken, the takeaway of this article is not for you to throw away your favorite DE and go full-on suckless. Rather, I wanted to outline my thoughts on the misalignments that have emerged between what I want out of my desktop, and what modern Linux Desktop Environments provide. I say this to disavow any sort of elitism that surrounds these alternate computing environments. Any perspective pitting complete out-of-the-box Linux DE users against users of "more technical" environemnts is an unhelpful false dichotomy. Rather, some of the [smartest](https://twitter.com/marcan42/status/872650013960134656) [engineers](https://twitter.com/alicela1n/status/1375481380998578177) I know use and promote KDE Plasma. The best DE (or lack thereof) is the one that is comfy for you.
