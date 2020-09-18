# Description

This repo contains cmake scripts to cross-compile the LPC1850-DB1 demos from Diolan using GCC.

# How to build

```
mkdir build
cd build
cmake ..
make
```

# Requirements

Cmake version 3.8 at least.

# Known Errors

Update included files names in emac.c and tcpip.c to respect the case-sensitivity in Linux (the project is made for being cross-compiled from Windows which is no case-sensitive).

```
emac.c:18:18: fatal error: EMAC.h: No such file or directory
emac.c:20:21: fatal error: lpc18xx.h: No such file or directory
tcpip.c:16:46: fatal error: EMAC.h: No such file or directory
```

So,
```
#include "EMAC.h"    > #include "emac.h"
#include "lpc18xx.h" > #include "LPC18xx.h"
```
