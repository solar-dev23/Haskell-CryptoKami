{-# LANGUAGE Rank2Types #-}
module Pos.Infra.Configuration
       ( InfraConfiguration (..)
       , HasInfraConfiguration
       , infraConfiguration
       , withInfraConfiguration
       , ntpServers
       ) where

import           Universum

import           Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import           Data.Reflection (Given, give, given)
import           Serokell.Aeson.Options (defaultOptions)

data InfraConfiguration = InfraConfiguration
    {
    --------------------------------------------------------------------------
    -- -- NTP slotting
    --------------------------------------------------------------------------
      ccNtpResponseTimeout          :: !Int
      -- ^ How often request to NTP server and response collection
    , ccNtpPollDelay                :: !Int
      -- ^ How often send request to NTP server
    , ccNtpMaxError                 :: !Int
    -- ^ Max NTP error (max difference between local and global time, which is trusted)

    , ccNeighboursSendThreshold     :: !Int
      -- ^ Broadcasting threshold
    , ccKademliaDumpInterval        :: !Int
      -- ^ Interval for dumping Kademlia state in slots
    , ccEnhancedMessageTimeout      :: !Word
    -- ^ We consider node as known if it was pinged at most @ccEnhancedMessageTimeout@ sec ago
    , ccEnhancedMessageBroadcast    :: !Word
      -- ^ Number of nodes from batch for enhanced bessage broadcast
    , ccNetworkWaitLogInterval      :: !Int
      -- ^ Network wait logging interval in seconds
      --   (logging that some recv/send takes significant amount of time)

    --------------------------------------------------------------------------
    -- -- Relay
    --------------------------------------------------------------------------
    , ccMaxReqSize                  :: !Word32
      -- ^ Maximum `ReqMsg` size in bytes
    , ccMaxInvSize                  :: !Word32
      -- ^ Maximum `InvMsg` size in bytes
    , ccMaxMempoolMsgSize           :: !Word32
      -- ^ Maximum `MempoolMsg` size in bytes

    --------------------------------------------------------------------------
    -- -- NTP checking
    --------------------------------------------------------------------------
    , ccTimeDifferenceWarnInterval  :: !Integer
      -- ^ NTP checking interval, microseconds
    , ccTimeDifferenceWarnThreshold :: !Integer
      -- ^ Maximum tolerable difference between NTP time
      -- and local time, microseconds
    } deriving (Show, Generic)

instance FromJSON InfraConfiguration where
    parseJSON = genericParseJSON defaultOptions

instance ToJSON InfraConfiguration where
    toJSON = genericToJSON defaultOptions

type HasInfraConfiguration = Given InfraConfiguration

withInfraConfiguration :: InfraConfiguration -> (HasInfraConfiguration => r) -> r
withInfraConfiguration = give

infraConfiguration :: HasInfraConfiguration => InfraConfiguration
infraConfiguration = given

ntpServers :: [String]
ntpServers =
    [ "0.pool.ntp.org"
    , "2.pool.ntp.org"
    , "3.pool.ntp.org"
    ]
    -- need only 3 servers :shrug:
