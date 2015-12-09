#!/usr/bin/env python

import os
import subprocess

if __name__ == '__main__':
    if os.environ.has_key('GRAPHICAL_APP'):
        graphical_app = os.environ['GRAPHICAL_APP']
        process = subprocess.Popen(graphical_app, shell=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        stdoutdata, stderrordata = process.communicate()
        print(stdoutdata)
        subprocess.call(['sudo', 'supervisorctl', 'shutdown'])
