{-# LANGUAGE GADTs #-}

module Chest.Link where

data Link where
  Link :: { _id :: Int
          , _name :: String
          , _resource :: String
          , _mime :: String
          } -> Link
