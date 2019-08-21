using PyCall: pyimport_conda, pycall
using RCall, Conda

function installpypackage()
	try
		pyimport_conda("sklearn", "scikit-learn")
	catch
		try
			Conda.add("scikit-learn")
		catch
			println("scikit-learn failed to install")
		end
	end
end

function installrpackage(package::AbstractString)
	try
		rcall(:library,package,"lib=.libPaths()")
		#rcall(:library,package,"lib=Sys.getenv('R_LIBS_USER')")
	catch
		try
			R"dir.create(path = Sys.getenv('R_LIBS_USER'), showWarnings = FALSE, recursive = TRUE)"
			R"install.packages($package,lib=Sys.getenv('R_LIBS_USER'),repos='https://cloud.r-project.org',type='binary')"
		catch xerror
			println(xerror)
			println("package "*package*" failed to install")
		end
	end
end

function installrml()
	#packages=["caret", "earth","mda","e1071","gam","randomForest","nnet","kernlab","grid","MASS","pls"]
	#packages=["caret", "e1071","gam","randomForest"]
	packages=["caret","e1071","randomForest"]
	for pk in packages
		installrpackage(pk)
	end
end

installrml()
installpypackage()
