# Core3 Linux Distribution
In April 2003, Josh Devin released a fairly refined and minimal Linux
distribution on CD-ROM. Though intended for 80386, a toolchain bug had
built it with i486 code. There was a Core 2 project that I followed,
which ended in Prime, but it used different approaches to building up a
system, and I had to fix things in the initial installs.

Devin's Core was not very upgradeable. As kernel releases moved things
forward, and packages needed to be patched for bugs, there wasn't a
mechanism for upgrading using the package manager. So I modified it to
include an upgrade feature.

Except CorePKG wasn't licensed for redistribution. I wrote Josh, and he
offered it under the GPL. His criteria was all versions of the GPL. The
FSF graciously provided me space to add CorePKG. I started it under
the GPLv1, then we changed that to GPLv2, then GPLv2 that had the
any-subsequent-version clause (which allows later versions).

I never stopped using my version of Core, which I stylized as sinuhe's
or D. E. Evans' Core, or Core 3. I later boot strapped it to AMD64 and
called that Core64.

So here are the final versions of my boot scripts from rebuilding Devin's
Core, refactored for improvements and consistency with Josh's approach, and
only making changes as package upgrades or more contemporary approaches
force changes to the existing system.  These are small systems, and
requires a small foot print to start.

Of note is the last 2.4.37.11 release, which was used on 80386 hardware
with 8 MB of RAM, and was carefully tested and stable. Also of note is the
last 2.6.27.62 release, which was originally boot strapped from Prime,
the last of the Core 2 systems. The 2025-07-16 restrospective was a
direct (i.e. not from Prime) derivative of 2.4.37.11, with the 2.6.18
builds as intermediate. (I followed Kroah-Hartman's book to ensure I
understood the new build process and dependencies correctly.)

The package info files give the general URL locations for downloading
packages. Contact me privately if an ISO is desired, as I no longer
have a website to post to. The current build was an intermediate beta,
as its successor was interrupted by hardware failure. For now, this
code base has been forked to core64, and will continue on with 5.4 and
then 6.18. I will pick up the core3 project at a future date, but will
stay on the oldest supported kernel as the oldest x86 hardware is small,
requires tuning, and hardware is more difficult to find. I intend a last
hurrah for i486 before moving to i586.

Gracious thanks to Ezra Pedersen for build hardware, and supporting me
with this retrospective project.
