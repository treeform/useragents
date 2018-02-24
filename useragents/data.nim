import json
import strutils
import streams
import re


type
  UserAgentEntry* = object
    regex*: Regex
    family_replacement*: string
    v1_replacement*: string
    v2_replacement*: string

  OSEntry* = object
    regex*: Regex
    os_replacement*: string
    os_v1_replacement*: string
    os_v2_replacement*: string
    os_v3_replacement*: string

  DeviceEntry* = object
    regex*: Regex
    regex_flag*: string
    device_replacement*: string
    brand_replacement*: string
    model_replacement*: string

var 
  userAgentRegexes* = newSeq[UserAgentEntry]()
  osRegexes* = newSeq[OSEntry]()
  deviceRegexes* = newSeq[DeviceEntry]()

const dataString = staticRead("regexes.json")
var data = parseJson(dataString)


proc safeGet(node: JsonNode, k: string): string =
  if k in node:
    node[k].getStr()
  else:
    ""

for node in data["user_agent_parsers"]:
  var e = UserAgentEntry()
  e.regex = re(node.safeGet("regex"), flags={})
  e.family_replacement = node.safeGet("family_replacement")
  e.v1_replacement = node.safeGet("v1_replacement")
  e.v2_replacement = node.safeGet("v2_replacement")
  userAgentRegexes.add(e)

for node in data["os_parsers"]:
  var e = OSEntry()
  e.regex = re(node.safeGet("regex"), flags={})
  e.os_replacement = node.safeGet("os_replacement")
  e.os_v1_replacement = node.safeGet("os_v1_replacement")
  e.os_v2_replacement = node.safeGet("os_v2_replacement")
  e.os_v3_replacement = node.safeGet("os_v3_replacement")
  osRegexes.add(e)

for node in data["device_parsers"]:
  var e = DeviceEntry()   
  e.regex_flag = node.safeGet("regex_flag")
  var regexStr = node.safeGet("regex")
  if e.regex_flag == "i":
    e.regex  = re(regexStr, flags={reIgnoreCase})
  elif e.regex_flag == "":
    e.regex  = re(regexStr, flags={})
  else:
    raise newException(Exception, "regex_flag not supported") 
  e.device_replacement = node.safeGet("device_replacement")
  e.brand_replacement = node.safeGet("brand_replacement")
  e.model_replacement = node.safeGet("model_replacement")
  deviceRegexes.add(e)



#[ 

for i, entry in regexes.user_agent_parsers:
  userAgentRegexes[i] = re(entry.regex, flags={})



for i, entry in regexes.os_parsers:
  osRegexes[i] = re(entry.regex, flags={})


for i, entry in regexes.device_parsers:
  if entry.regex_flag == "i":
    deviceRegexes[i] = re(entry.regex, flags={reIgnoreCase})
  elif entry.regex_flag == "":
    deviceRegexes[i] = re(entry.regex, flags={})
  else:
    raise newException(Exception, "regex_flag not supported")
 ]#