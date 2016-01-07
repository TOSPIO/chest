module Chest.Store where

import           Chest.Db
import           Chest.Link


search :: String -> IO [Link]
search = withConnection $ \con -> undefined


add :: Link -> IO ()
add = undefined


delete :: Link -> IO ()
delete = undefined


deleteByName :: Link -> IO ()
deleteByName = undefined
