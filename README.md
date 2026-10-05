# Core3 Linux Distribution
In April 2003, Josh Devin released a fairly refined and minimalized Linux
distribution on CD-ROM. Think of it like a mini-version of LFS (which
I suspect it was based on). I'm a Slackware user, and that distribution
has some influences on my approach to upgrading Core. There was a Core 2
project that ended in Prime, but it used different approaches to building
up a system.

For me, I just used what I was given the way it was intended to be used:
installing to an Intel computer, then building it up.

The problem was it was not very upgradeable, and as kernel releases
moved things forward, and packages needed to be patched for bugs, it
didn't have a mechanism for upgrading using the package manager.  So I
modified it to include an upgrade feature.

Except it wasn't licensed for redistribution. So I wrote Josh, and he
offered it under the GPL. His criteria was all versions of the GPL. I
contacted the FSF and they provided me space to add corepkg. I started
it under the GPLv1, and then we changed that to GPLv2, then GPLv2 that
had the any-subsequent-version clause.

I never stopped using my version of Core, which I stylized as D. E. Evans'
Core, or Core 3. When Slackware64 released, I boot strapped it to AMD64 and
called that Core64. Past versions were sCore and sGOS for sinuhe's Core
and sinuhe's GNU/Linux OS. (sinuhe is my handle with the GNU Project.)
I made changes to the name to avoid trademarks which led me back to
Josh's name.

So here are the boot scripts for Core 3, the 32-bit version, as I
upgraded the base successfully each time, then reinstalled and added
my own packages along the way. I keep those packages as a separate
build-system for modifying the installed version, keeping the IUR,
or live install version, small and consistent with Josh's original.

I'll start from the beginning, where the goal is to reproduce the original
as closely as possible, with some modifications, then update. If you have
Josh's original ISO, and old 32-bit hardware with a CD-ROM, this first
set, and the second, should give you what you need to upgrade. There's
more to follow.
