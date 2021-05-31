#!/usr/bin/env python3
import xml.dom.minidom

mdFile = """# Test Results

| Legend |  |
|:------:|:-------:|
| ✅ | Passed |
| ❗️ | Failed |
"""

doc = xml.dom.minidom.parse("Tests/Results.xml")

results = dict()

class Result:
    def __init__(self, classname, name, time, failed):
        self.classname = classname
        self.name = name
        self.time = time
        self.failed = failed

def handleTestcase(testcase):
    result = Result(
        testcase.getAttribute("classname").replace("SwiftInterpreterTests.", ""),
        testcase.getAttribute("name"),
        testcase.getAttribute("time"),
        len(testcase.getElementsByTagName("failure")) > 0
    )
    if result.classname in results:
        results[result.classname].append(result)
    else:
        results[result.classname] = [result]


def handleTestsuites(doc):
    for testcase in doc.getElementsByTagName("testcase"):
        handleTestcase(testcase)

handleTestsuites(doc)

def writeResultsToMdFile():
    global mdFile
    keys = sorted(results.keys())
    for key in keys:
        mdFile = mdFile + """
### """ + key + """
| Result | Test Name | Time |
|:------:|:-------:|:-------:|
"""
        values = sorted(results[key], key=lambda el: el.name)
        for result in values:
            if result.failed:
                mdFile = mdFile + "| ❗️ "
            else:
                mdFile = mdFile + "| ✅ "
            mdFile = mdFile + "|" + result.name
            mdFile = mdFile + "|" + result.time
            mdFile = mdFile + "|" + result.time + "|"
            mdFile = mdFile + "\n"

writeResultsToMdFile()

f = open("TEST_RESULTS.md", "w")
f.write(mdFile)
f.close()