{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_myproj (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/bin"
libdir     = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/lib/x86_64-linux-ghc-8.8.3/myproj-0.1.0.0-CqTztOEJzBcCw947naPWBI-myproj-exe"
dynlibdir  = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/lib/x86_64-linux-ghc-8.8.3"
datadir    = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/share/x86_64-linux-ghc-8.8.3/myproj-0.1.0.0"
libexecdir = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/libexec/x86_64-linux-ghc-8.8.3/myproj-0.1.0.0"
sysconfdir = "/home/poster/sirius/myproj/.stack-work/install/x86_64-linux-tinfo6/89e4559ef73e3e5ebfe31cfdcdb98d7be840d8e5d588f8595ef2a56ea5417019/8.8.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "myproj_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "myproj_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "myproj_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "myproj_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "myproj_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "myproj_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
