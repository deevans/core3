# Core3 Linux Distribution
In April 2003, Josh Devin released a fairly refined and minimalized Linux
distribution on CD-ROM. There was a Core 2 project that I followed, which
ended in Prime, but it used different approaches to building up a system,
and I had to fix a bunch of things in the initial installs. I preferred to
use what I was given: install to an Intel computer, then build from there.

The problem was Devin's Core was not very upgradeable. As kernel
releases moved things forward, and packages needed to be patched for
bugs, there wasn't a mechanism for upgrading using the package manager.
So I modified it to include an upgrade feature.

Except CorePKG wasn't licensed for redistribution. I wrote Josh, and he
offered it under the GPL. His criteria was all versions of the GPL. I
contacted the FSF and they provided me space to add CorePKG. I started
it under the GPLv1, and then we changed that to GPLv2, then GPLv2 that
had the any-subsequent-version clause.

I never stopped using my version of Core, which I stylized as sinuhe's
or D. E. Evans' Core, or Core 3. I later boot strapped it to AMD64 and
called that Core64, but have treated it as a fork.

So here are the final versions of my boot scripts from rebuilding
Devin's Core, refactored for improvements and consistency with Josh's
approach. The goal is to keep the IUR, or live install version, small
and consistent with Josh's original, making changes as package upgrades
or more contemporary approaches force changes to the existing system.

The package info files give the general URL locations for downloading
packages. Running this requires 32-bit Intel hardware with an IDE
CD-ROM. Installation requires an IDE ATA drive. Contact me privately if
an ISO is desired, as I no longer have a website to post to.

This is the last 2.4 kernel, though I didn't include some of the later
October patches from Willy. It is the last version I supported on 80386,
mainly due to threading support changes, not kernel specific ones. It was
tested on a real 80386 Intel with 8 MB of RAM, and it ran (and still runs)
great. This release is dedicated to Michael Scott Clyde, who used an old
version of this back in 2010. This is a retrospective release, and the
next that follows was one I had intended to build for him, but didn't get
a chance.
