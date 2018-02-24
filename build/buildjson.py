# To build run python build/buildjson.py 

import yaml
import json

def convert(filePath):
	print filePath
	with open(filePath) as f:
	    dataMap = yaml.safe_load(f)
	    dataJson = json.dumps(dataMap, indent=2)
	    with open(filePath.replace(".yaml", ".json"), 'wb') as f2:
	    	f2.write(dataJson)


convert('tests/test_device.yaml')
convert('tests/test_os.yaml')
convert('tests/test_ua.yaml')
convert('useragents/regexes.yaml')