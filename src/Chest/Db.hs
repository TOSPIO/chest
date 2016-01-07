{-# LANGUAGE OverloadedStrings #-}

module Chest.Db ( linkSchema
                , getConnection
                , createDatabaseIfNotExists
                , withConnection
                )
       where

import           Chest.Config
import           Chest.Link
import           Control.Monad
import           Data.HashMap    as HM
import           Data.Map
import           Data.Maybe
import           Database.SQLite


data ColumnDefs = ColumnDefs { cdId       :: String
                             , cdName     :: String
                             , cdMime     :: String
                             , cdResource :: String
                             }

columnDefs :: ColumnDefs
columnDefs = ColumnDefs { cdId = "id"
                        , cdName = "name"
                        , cdMime = "mime"
                        , cdResource = "resource"
                        }

linkSchema :: SQLTable
linkSchema = Table
  { tabName = _tabName
  , tabColumns = [ Column
                   { colName = "id"
                   , colType = SQLInt BIG True{- unsigned -} False{- zerofill -}
                   , colClauses = [PrimaryKey True{- auto-increment -}]
                   }
                 , Column
                   { colName = "name"
                   , colType = SQLVarChar 255
                   , colClauses = [Unique]
                   }
                 , Column
                   { colName = "mime"
                   , colType = SQLVarChar 100
                   , colClauses = []
                   }
                 , Column
                   { colName = "resource"
                   , colType = SQLVarChar 65535
                   , colClauses = []
                   }
                 ]
  , tabConstraints = []
  }
  where
    _tabName = "link"


getConnection :: IO SQLiteHandle
getConnection = openConnection $ getDbConnectionString config


createDatabaseIfNotExists :: SQLiteHandle -> IO ()
createDatabaseIfNotExists h = void $ defineTableOpt h True linkSchema


withConnection :: (SQLiteHandle -> IO a) -> IO ()
withConnection = void . (>>=) getConnection


{-# INLINE rowToLink #-}
rowToLink :: Row Value -> Link
rowToLink row =
  Link { _id = let (Int _id) = fromJust $ getColumnVal cdId in fromIntegral _id
       , _name = let (Text _name) = fromJust $ getColumnVal cdName in _name
       , _mime = let (Text _mime) = fromJust $ getColumnVal cdMime in _mime
       , _resource = let (Text _resource) = fromJust $ getColumnVal cdResource in _resource
       }
  where
    hashmap = HM.fromList row
    getColumnVal cdf = HM.lookup (cdf columnDefs) hashmap
    extractVal = undefined
