#!/usr/bin/python
#!/usr/bin/python

from AppKit import NSMutableDictionary
import os

def increaseVersion():
    # reading svn version
    version = os.popen('svnversion -n').read()
    
    version = version.split(':')[-1]
    
    if not version[-1].isdigit():
        version = version[:-1]
    
    # reading info.plist file
    projectPlist = NSMutableDictionary.dictionaryWithContentsOfFile_('Info.plist')
    
    # setting the svn version for CFBundleVersion key
    projectPlist['CFBundleVersion'] = version
    projectPlist.writeToFile_atomically_('Info.plist', True)

if __name__ == '__main__':
    increaseVersion()
