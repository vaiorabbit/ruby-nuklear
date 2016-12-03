
local action = _ACTION or ""

solution "nuklear"
	location ( "build" )
	configurations { "Release", "ReleaseDLL" }
	platforms {"native", "x64", "x32"}

	local homepath = os.getenv("HOME")

	project "nuklear"
		language "C"
		includedirs { "../nuklear/" }
		files { "nuklear_dll.c" }
		targetdir("build")

		configuration "windows"
			-- files { "nuklear.def" }
			defines { "_CRT_SECURE_NO_WARNINGS" }
			-- includedirs { homepath .. "/Libraries/glext/" }
			libdirs { }
			postbuildcommands { "cp nuklear.dll ../../demo" }

		configuration "macosx"
			postbuildcommands { "cp libnuklear.dylib ../../demo" }

		configuration "linux"
			postbuildcommands { "cp libnuklear.so ../../demo" }

		configuration "Release"
			kind "StaticLib"
			-- defines { "NDEBUG", "NUKLEAR_DLL_BUILD" }
			flags { "Optimize", "ExtraWarnings" }

		configuration "ReleaseDLL"
			kind "SharedLib"
			-- defines { "NDEBUG", "NUKLEAR_DLL_BUILD" }
			flags { "Optimize", "ExtraWarnings" }
