User Agent parser for nim.
==========================

Module provides just one function to parse a user agent:

```lang:nim
import useragents
echo parseUserAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36")
```

Provides 5,000 lines of regex and another 90,000 lines of tests to make sure event the most arcane user agents are parsed.
Based on the work done by: https://github.com/ua-parser/uap-core
