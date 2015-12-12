#!/usr/bin/env python

import os
import subprocess

if __name__ == '__main__':
    if os.environ.has_key('APP'):
        graphical_app = os.environ['APP']
        if os.environ.has_key('ARGS'):
            extra_args = os.environ['ARGS']
            command = graphical_app + ' ' + extra_args
        else:
            command = graphical_app

        process = subprocess.Popen(command, shell=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        stdoutdata, stderrordata = process.communicate()
        print(stdoutdata)
        subprocess.call(['sudo', 'supervisorctl', 'shutdown'],
                        stdout=subprocess.PIPE)
        return_code = process.returncode
        print('Graphical app return code: ' + str(return_code))
