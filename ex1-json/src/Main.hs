{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Data.Aeson hiding (json)
import Web.Spock.Safe
import GHC.Generics

data Person = Person { name    :: String
                     , age     :: Integer
                     , address :: String
                     } deriving Generic

instance ToJSON Person

listPeople :: [Person]
listPeople = [ Person "Fulanito"  30 "Boulder, CO"
             , Person "Menganito" 25 "Madrid, ES"
             , Person "Zutano"    35 "Utrecht, NL"
             ]

data Task = Task { title :: String
                 , description :: String
                 , person :: Person}

main :: IO ()
main = runSpock 8080 $ spockT id $ do
  -- /hello/:name
  get ("hello" <//> var) $ \name ->
    json $ object [ "hello" .= String name ]
  -- /allow/:age
  get ("allow" <//> var) $ \(age :: Integer) ->
    json $ object [ "allowed" .= Bool True]
  get ("person" <//> var) $
    json . (!!) listPeople
