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

def remove_prefix(text, prefix):
    return text[text.startswith(prefix) and len(prefix):]

class Result:
    def __init__(self, classname, name, time, failed, link):
        self.classname = classname
        self.name = name
        self.time = time
        self.failed = failed
        self.link = link

def handleTestcase(testcase):
    classname = testcase.getAttribute("classname").replace("SwiftInterpreterTests.", "")
    name = testcase.getAttribute("name")
    result = Result(
        classname,
        name,
        testcase.getAttribute("time"),
        len(testcase.getElementsByTagName("failure")) > 0,
        "https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/Tests/SwiftInterpreterTests/CodeTests/" + classname + "/" + remove_prefix(AnotherOne.rstrip(string.digits), "test") + ".swift"
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
| Result | Test Name | Time | Code |
|:------:|:-------:|:-------:|:-------:|
"""
        values = sorted(results[key], key=lambda el: el.name)
        for result in values:
            if result.failed:
                mdFile = mdFile + "| ❗️ "
            else:
                mdFile = mdFile + "| ✅ "
            mdFile = mdFile + "|" + result.name
            mdFile = mdFile + "|" + result.time
            mdFile = mdFile + "|" + result.time
            mdFile = mdFile + "|[View Code](" + result.link + ")|"
            mdFile = mdFile + "\n"

writeResultsToMdFile()

f = open("TEST_RESULTS.md", "w")
f.write(mdFile)
f.close()
