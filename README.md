## drd: Docker R-devel 

This repository aims to provide (possibly daily) builds of Docker containers based on
the then-current state of the R-devel SVN repository.

It is now part of the [rocker](https://github.com/eddelbuettel/rocker)
repository in which @cboettig and @eddelbuettel are now working, and it
builds upon earlier Docker repos and automated builds in Dirk's repositories.

#### So what about r-devel in Rocker then?

Excellent question, but the answer will get nerdy quickly.  Docker containers
are composed of layers implemented via [AUFS](http://en.wikipedia.org/wiki/Aufs).
Each `RUN` command is one layer. This makes it impossible to reclaim
filespace from an earlier layer in a later layer -- so the R-devel container
can not easily remove (temp.) files and directories.

For drd we went the other route: The container is built in a _single_
invocation of `RUN` which permits us to reclaim space for an overall smaller
container.  But it is sort-of running against the grain of how Docker
containers are built, and hence still somewhat experimental.

But if you just want a smaller container with a current R-devel build, this
may be the one.

#### Date

This build was triggered Thu Nov  6 09:18:38 CST 2014.

