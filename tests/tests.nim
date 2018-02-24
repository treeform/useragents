import unittest
import json
import streams

import ../useragents


type
  TestEntry = object
    user_agent_string: string
    family: string
    major: string
    minor: string
    patch: string
    patch_minor: string
    brand: string
    model: string

  TestFile = object
    test_cases: seq[TestEntry]

proc safeGet(node: JsonNode, k: string): string =
  if k in node:
    node[k].getStr()
  else:
    ""

suite "test":
  test "basic":
    assert parseUserAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36") ==
      UserAgent(
        browserName: "Chrome",
        browserMajorVersion: "61",
        browserMinorVersion: "0",
        browserPatchVersion: "3163",
        browserPatchMinorVersion: "",
        osName: "Mac OS X",
        osMajorVersion: "10",
        osMinorVersion: "12",
        osPatchVersion: "3",
        osPatchMinorVersion: "",
        deviceName: "Other",
        deviceBrand: "",
        deviceModel: ""
      )

  test "browser":
   
    var s = parseFile("tests/test_ua.json")

    for test in s["test_cases"]:
      var userAgent = parseUserAgent(test.safeGet("user_agent_string"))
      assert userAgent.browserName == test.safeGet("family")
      assert userAgent.browserMajorVersion == test.safeGet("major")
      assert userAgent.browserMinorVersion == test.safeGet("minor")
      assert userAgent.browserPatchVersion == test.safeGet("patch")
      # no tests for patch minor
      #assert userAgent.browserPatchMinorVersion == test.safeGet("patch_minor")

  test "os":
 
    var s = parseFile("tests/test_os.json")

    for test in s["test_cases"]:
      var userAgent = parseUserAgent(test.safeGet("user_agent_string"))
      assert userAgent.osName == test.safeGet("family")
      assert userAgent.osMajorVersion == test.safeGet("major")
      assert userAgent.osMinorVersion == test.safeGet("minor")
      assert userAgent.osPatchVersion == test.safeGet("patch")
      assert userAgent.osPatchMinorVersion == test.safeGet("patch_minor")

  test "device":
 
    var s = parseFile("tests/test_device.json")
    
    for test in s["test_cases"]:
      var userAgent = parseUserAgent(test.safeGet("user_agent_string"))
      assert userAgent.deviceName == test.safeGet("family")
      assert userAgent.deviceBrand == test.safeGet("brand")
      assert userAgent.deviceModel == test.safeGet("model")
