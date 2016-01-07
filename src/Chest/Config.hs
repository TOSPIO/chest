{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RecordWildCards           #-}

module Chest.Config where


class DbConfig dbConfig where
  getConnectionString :: dbConfig -> String

newtype SQLiteDbConfig = SQLiteDbConfig { unDbConfig :: String }
instance DbConfig SQLiteDbConfig where
  getConnectionString = unDbConfig

data Config = forall dbConfig.(DbConfig dbConfig) =>
              Config { dbConfig :: dbConfig }

getDbConnectionString :: Config -> String
getDbConnectionString Config{..} = getConnectionString dbConfig

config :: Config
config = Config
  { dbConfig = SQLiteDbConfig
    { unDbConfig = "chest.db" }
  }
