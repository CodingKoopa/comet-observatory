## Disillusionment with the Linux Desktop Environment

### A retrospective

I've used a pretty decent array of the major Desktop Environments (DEs) that are available for use. I used Ubuntu casually, back when Canonical shipped the Unity desktop, to which I can't really speak on in any technical capacity. My experience with the rest of the DEs I have tried is more nuanced, yet there is still some difficulty in speaking on them because it's been at most 2-3 years since I've tried some of tiem, which in Linux time can bring a lot of changes, depending on the pace of development.

The story of this section begins and ends with me deriving curiosity and inspiration from other people's Linux desktops. When I was planning on installing Arch Linux, I was somewhat on the market for a DE - although I definitely didn't know this term at the time. I saw a tweet featuring the Budgie desktop by Solus, and I thought that it looked pretty, so I asked the author what they were using. And then I used it.

Frankly, the details are a little hazy; it's within the realm of possibilities that this heavily influenced my distro choice too.

Budgie isn't bad; it was just really limited in customization when I used it, and I imagine that this is still a part of the general design direction. In spite of this, I'm not aware of it being especially light on resources, but the simple UI still is attracting; I might use this if I ever needed a ChromeOS-like interface on a device that has enough processing power. I moved on from Budgie when I really needed more control over my desktop.

TODO: quark tweet


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

To say that the aim of the KDE project is daunting would be an understatement. There is an incomprehensible amount of variables for the developers to consider, including how different parts of the desktop stack interact with each other, different distributions, and the sheer amount of code they maintain under the KDE umbrella. Similar things can be said about the Arch Linux package maintainers, or the GNOME developers (yes, be nice), or anyone else who works to provide for the Linux desktop.

But it's not where it should be, still.

I often think about how much of a well-oiled machine kernel development is, in contrast to how much more seemingly strapped for resources the desktop scene is. Compared to the kernel's strict standards for quality, the desktop seems to struggle to deliver an excellent experience. In some departments, we are now catching up to what *should* be expected from a modern desktop, but as a whole it feels like we are lagging behind.

In 2017, [probono](https://github.com/probonopd) wrote the first entry of his series ["Make. It. Simple. Linux Desktop Usability"](https://medium.com/@probonopd/make-it-simple-linux-desktop-usability-part-1-5fa0fb369b42). This series is a brilliant dive into many of the issues that the Linux desktop have, which I won't be repeating here. In addition to identifying inconsistencies in the user experience, he reviews how many of these conceptual challenges have been long but solved by older yet more intuitive user interfaces.

My disillusionment with the Linux desktop is less profound; the issues I have with KDE are more surface level pains that I don't see going away any time soon.

#### Configuration Pains

There is more than enough discourse on the internet about how oh so hard it is to configure KDE Plasma. I sympathize with these concerns, but it's never annoyed me too much, and I am aware that the KDE developers have been working to make the system settings more approachable. What does frustrate me, is the storage of configuration files.

Plasma's user configuration state is just about all in `~/.config`, in `rc` files. The names of the RC files is often undocumented, resulting in you having to take a best guess as to which `rc` file is the right one.

So, let's say I want to take my Plasma panel, and put it on a different setup. I looked around my `~/.config` and located a `plasmashellrc` file. This is an excerpt of some of its contents:
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
- Keys for recent files and URLs. This isn't so much a configuration value as it is a "user data" value, or perhaps a "cached" value (see `~/.local/share` and `~/.config` respectively).
- Some (undocumented) configuration values. There's not much a human with a text editor can do with this, still, but it *is* a configuration value and I can vaguely tell what is going on.

There is a poor separation between configuration values, and state values that are aren't so much settings as they are properties that the program sets at its own will. I've seen this with other Qt programs (and have done this myself), where it's easiest to take persistent state values like window geometry, and stuff it in with the rest of the configuration values. As a pain point, this will manifest if you ever try to take your configuration file, and sync it with the cloud. You will notice that, even though you haven't changed any settings, new uploads will be triggered periodically. This would be a relatively small thing to fix for a program - maybe not so much on the scale of KDE, though.

The other issue here, though, is one which systematically applies to nearly every program which provides a GUI configuration, and has a much less clear path forward.

// TODO: write the rest :)
// TODO: VSCode does good with this
