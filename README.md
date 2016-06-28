# Nuklear-Bindings : A Ruby bindings for Nuklear UI Library #

Provides Nuklear ( https://github.com/vurtun/nuklear ) interfaces for ruby (MRI).

*   Created : 2016-06-23
*   Last modified : 2016-06-28

## Prerequisites ##

*   Ruby-FFI ( https://github.com/ffi/ffi )
    *   $ gem install ffi

*   For demo/example.rb : opengl-bindings ( https://github.com/vaiorabbit/ruby-opengl )
    *   $ gem install opengl-bindings

## How to Use ##

1. Build Nuklear shared library
    *   See nuklear_dll

2. Include nuklear.rb in your script.
    *   ex.) require_relative 'nuklear'

3. Load shared library
    *   ex.) Nuklear.load_lib('libnuklear.dylib')

4. Setup OpenGL

See demo/example.rb for details.

## License ##

All source codes are available under the terms of the zlib/libpng license.

	Nuklear-Bindings : A Ruby bindings for Nuklear
	Copyright (c) 2016 vaiorabbit
	
	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	    1. The origin of this software must not be misrepresented; you must not
	    claim that you wrote the original software. If you use this software
	    in a product, an acknowledgment in the product documentation would be
	    appreciated but is not required.
	
	    2. Altered source versions must be plainly marked as such, and must not be
	    misrepresented as being the original software.
	
	    3. This notice may not be removed or altered from any source
	    distribution.
