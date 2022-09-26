# -*- coding: utf-8 -*-
"""
Created on Mon Jul 25 18:38:37 2022

@author: cukelarter
Function to change CWD to current file. Shouldn't be necessary or needs refactoring since it would be an imported module/function.
"""
#%% Imports and Setup
import sys
import os
import inspect

# Change CWD - ! Not necessary if set manually in IDE
def get_script_dir(follow_symlinks = True):
    # retreive directory of this file for use in setting CWD
    if getattr(sys, 'frozen', False):
        path = os.path.abspath(sys.executable)
    else:
        path = inspect.getabsfile(get_script_dir)
    if follow_symlinks:
        path = os.path.realpath(path)
    return os.path.dirname(path)

script_dir = get_script_dir() # retreive containing directory of file
os.chdir(script_dir)          # set CWD to containing directory

if __name__=='__main__':
    pass