# Core3 Linux Distribution
In April 2003, Josh Devin released a fairly refined and minimalized
Linux distribution on CD-ROM. Think of it like a mini-version of LFS
(which I actually think it was based on). I'm a Slackware user, and that
distribution has some influences on my approach to upgrading Core. There
was a Core 2 project that ended in Prime, but it used different approaches
to building up a system.

For me, I just used what I was given the way it was intended to be used:
installing to an Intel computer, then building it up.

The problem was it was not very upgradeable, and as kernel releases
moved things forward, and packages needed to be patched for bugs, it
didn't have a mechanism for upgrading using the package manager.  So I
modified it to include an upgrade feature, and that solved the problem.

Except it wasn't licensed for redistribution. So I wrote Josh, and I he
offered it under the GPL. His criteria was all versions of the GPL. I
contacted the FSF and they provided me space to add corepkg. I started
it under the GPLv1, and then we changed that to GPLv2, then GPLv2 that
had the any subsequent version clause.

I never stopped using my version of Core, which I stylized as D. E. Evans'
Core, or Core 3. When Slackware64 released, I boot strapped it to AMD64
and called it Core64. Past versions were sCore and sGOS for sinuhe's
Core and sinuhe's GNU/Linux OS. (sinuhe is my handle with the GNU Project.)

So here are the boot scripts for Core 3, the 32-bit version, as I
upgraded the base successfully each time, then reinstalled and added
my own packages along the way. I keep those packages as a separate
build-system for modifying the installed version, keeping the installer,
or live version, small, consistent with Josh's original.

I'll start from the beginning, where the goal is to reproduce the original
as closely as possible, with some modifications, then update. If you have
Josh's original ISO, and old 32-bit hardware with a CD-ROM, this first set,
and the second, should give you what you need to upgrade. An ISO exists
of my last 80386 version. I'm working on a final 5.4 cut, then I will
upgrade from there. I'll keep an ISO for the final i486 cut, but after
5.17, more RAM is required (32 MB or more) and an actual functioning
80486 Intel might be difficult to run (needing a larger hard drive, a
little over 1G now). I may keep the 5.15 LTS version until I can prove
the 6.x kernel builds will actually run on an 80486. I've kept Devin's
optimizations as best I can to keep it small to install on old hardware.
