{-# LANGUAGE DeriveGeneric   #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    , connectToDB
    , fetchFromDB
    ) where

import Data.Text
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp

import Servant

import Servant.API.Generic
import Servant.Server.Generic

import qualified Hasql.Connection
import qualified Data.ByteString.UTF8 as BSU

import qualified Hasql.Session
import qualified Hasql.Statement
import qualified Hasql.Encoders
import qualified Hasql.Decoders as Decoders

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

data Node = Node
  { nodeId :: Int
  , label  :: String
  } deriving (Eq, Show)


$(deriveJSON defaultOptions ''Node)

data Routes route = Routes
    { _get :: route :- "users" :> Get '[JSON] [User]
    }
  deriving (Generic)

type API = "users" :> Get '[JSON] [User]

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = genericServe record

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy :: Proxy Routes)

record :: Routes AsServer
record = Routes
    { _get = return users
    }

users :: [User]
users = [ User 1 "Isaac" "Newton"
        , User 2 "Albert" "Einstein"
        ]

connectionSettings :: Hasql.Connection.Settings
connectionSettings =
  Hasql.Connection.settings
    (BSU.fromString "localhost")
    (fromInteger 5432)
    (BSU.fromString "poster")
    (BSU.fromString "password")
    (BSU.fromString "")

connectToDB :: IO ()
connectToDB = do
    connectionResult <- Hasql.Connection.acquire connectionSettings
    case connectionResult of
      Left (Just errMsg) -> error $ show errMsg
      Left Nothing -> error "Unspecified connection error"
      Right connection -> do
        putStrLn "Acquired connection!"
        Hasql.Connection.release connection

selectNodesStatement :: Hasql.Statement.Statement () [Node]
selectNodesStatement =
  Hasql.Statement.Statement
    (BSU.fromString "SELECT id, label FROM nodes")
    mempty
    (Decoders.rowList $ Node <$> (Decoders.column $ Decoders.nonNullable $ fromEnum <$> Decoders.int8) <*> (Decoders.column $ Decoders.nonNullable $ Data.Text.unpack <$> Decoders.text))
    True

selectNodesSession :: Hasql.Session.Session [Node]
selectNodesSession = Hasql.Session.statement () selectNodesStatement

fetchFromDB :: IO [Node]
fetchFromDB = do
    connectionResult <- Hasql.Connection.acquire connectionSettings
    case connectionResult of
      Left (Just errMsg) -> error $ show errMsg
      Left Nothing -> error "Unspecified connection error"
      Right connection -> do
        queryResult <- Hasql.Session.run selectNodesSession connection
        Hasql.Connection.release connection
        case queryResult of
          Right result -> return result
          Left err -> error $ show err
