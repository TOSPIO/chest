{-# LANGUAGE GADTs #-}

module Chest.Link where

import Data.Text
import Codec.MIME.Type

data Link where
  Link :: { resource :: String
          , mime :: String
          } -> Link
