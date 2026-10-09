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

So here are my boot scripts for rebuilding Devin's Core, refactored for
improvements and consistency with Josh's approach. The goal is to keep the
IUR, or live install version, small and consistent with Josh's original,
making changes as package upgrades or more contemporary approaches force
changes to the existing system.

The package info files give the general URL locations for downloading
packages. Installation requires old, 32-bit Intel hardware with a
CD-ROM. Contact me privately if an ISO is desired.
