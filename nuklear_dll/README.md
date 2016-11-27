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

Setup appropriate DevKit (e.g. http://rubyinstaller.org/add-ons/devkit/ ) before proceed.

	*   Open 'msys.bat' (if you use RubyInstaller's DevKit).
	$ ~/Programs/premake/premake4.exe --cc=gcc --os=windows gmake
		Building configurations...
		Running action 'gmake'...
		Generating build/Makefile...
		Generating build/nuklear.make...
		Done.
	$ cd build
	$ make config=releasedll nuklear
		...
		Linking nuklear
		Running post-build commands
		cp nuklear.dll ..\..\demo
	$ ls -l ../../demo/*dll
		-rwxr-xr-x 1 foo bar 256512 Nov 27 15:55 ../../demo/nuklear.dll
