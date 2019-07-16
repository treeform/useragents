## User Agent parser for nim.
## ==========================
##
## Module provides just one function parse user agent:
##
## .. code-block:: nim
##     import useragents
##     echo parseUserAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36")
##
## Provides 5,000 lines of regex and another 90,000 lines of tests to make sure event the most arcane user agnets are parsed.
## Based on the work done by: https://github.com/ua-parser/uap-core
##

import useragents.data
import re
import strutils


type
  UserAgent* = object
    ## Parsed out UserAgnet
    browserName*: string
    browserMajorVersion*: string
    browserMinorVersion*: string
    browserPatchVersion*: string
    browserPatchMinorVersion*: string

    osName*: string
    osMajorVersion*: string
    osMinorVersion*: string
    osPatchVersion*: string
    osPatchMinorVersion*: string

    deviceName*: string
    deviceBrand*: string
    deviceModel*: string


proc replaceMatches(s: string, matches: array[5, string]): string =
  result = ""
  var i = 0
  while i < s.len:
    var c = s[i]
    if c == '$':
      var which = ord(s[i+1]) - ord('1')
      assert which >= 0 and which < matches.len
      if matches[which] != "":
        result &= matches[which]
      inc i
    else:
      result &= c
    inc i


proc parseUserAgent*(userAgent: string): UserAgent =
  ## Turns a string into a parsed out user agent structure
  result = UserAgent()

  result.browserName = "Other"
  result.browserMajorVersion = ""
  result.browserMinorVersion = ""
  result.browserPatchVersion = ""
  result.browserPatchMinorVersion = ""

  for i, entry in userAgentRegexes:
    var matches: array[5, string]
    let bounds = userAgent.findBounds(userAgentRegexes[i].regex, matches)
    if bounds.first != -1:
      if entry.family_replacement != "":
        result.browserName = entry.family_replacement.replace("$1", matches[0])
      else:
        result.browserName = matches[0]

      if entry.v1_replacement != "":
        result.browserMajorVersion = entry.v1_replacement
      else:
        result.browserMajorVersion = matches[1]

      if entry.v2_replacement != "":
        result.browserMinorVersion = entry.v2_replacement
      else:
        result.browserMinorVersion = matches[2]
      result.browserPatchVersion = matches[3]
      result.browserPatchMinorVersion = matches[4]
      break

  result.osName = "Other"
  result.osMajorVersion = ""
  result.osMinorVersion = ""
  result.osPatchVersion = ""
  result.osPatchMinorVersion = ""

  for i, entry in osRegexes:
    var matches: array[5, string]
    let bounds = userAgent.findBounds(osRegexes[i].regex, matches)
    if bounds.first != -1:
      if entry.os_replacement != "":
        result.osName = entry.os_replacement.replace("$1", matches[0])
      else:
        result.osName = matches[0]

      if entry.os_v1_replacement != "":
        result.osMajorVersion = entry.os_v1_replacement
      else:
        result.osMajorVersion = matches[1]

      if entry.os_v2_replacement != "":
        result.osMinorVersion = entry.os_v2_replacement
      else:
        result.osMinorVersion = matches[2]

      if entry.os_v3_replacement != "":
        result.osPatchVersion = entry.os_v3_replacement
      else:
        result.osPatchVersion = matches[3]

      result.osPatchMinorVersion = matches[4]

      break

  result.deviceName = "Other"
  result.deviceBrand = ""
  result.deviceModel = ""

  for i, entry in deviceRegexes:
    var matches: array[5, string]
    let bounds = userAgent.findBounds(deviceRegexes[i].regex, matches)

    if bounds.first != -1:

      if entry.device_replacement != "":
        result.deviceName = replaceMatches(entry.device_replacement, matches)
      else:
        result.deviceName = matches[0]
      result.deviceName = result.deviceName.strip()

      if entry.brand_replacement != "":
        result.deviceBrand = replaceMatches(entry.brand_replacement, matches)
      result.deviceBrand = result.deviceBrand.strip()

      if entry.model_replacement != "":
        result.deviceModel = replaceMatches(entry.model_replacement, matches)
      else:
        result.deviceModel = matches[0]
      result.deviceModel = result.deviceModel.strip()

      break
