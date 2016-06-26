<!-- -*- mode:markdown; coding:utf-8; -*- -->

## Building libnuklear.dylib ##

### Premake ###

Build scripts are generated via Premake ( https://premake.github.io ).
Please install it before proceed.

	$ brew install premake # for Mac OS X

### Steps ###

#### Mac OS X ####

	$ premake4 --cc=gcc --os=macosx gmake
		Building configurations...
		Running action 'gmake'...
		Generating build/Makefile...
		Generating build/Makefile...
		Generating build/nuklear.make...
		Done.
	
	$ cd build
	
	$ make config=releasedll nuklear
		==== Building nuklear (releasedll) ====
		...
		Linking nuklear
		...
	
	$ ls -l ../../demo/*dylib
		-rwxr-xr-x  1 foo  bar  274372  6 23 22:55 ../../demo/libnuklear.dylib

#### Windows ####

	> %home%\Programs\premake\premake4.exe vs2012
	* Open build\nuklear.sln with Visual Studio
	* Build 'nuklear' with ReleaseDLL/x64 configuration.
	* You get nuklear.dll in demo folder.
