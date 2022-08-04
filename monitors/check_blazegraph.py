#!/usr/bin/env python3
#mike b, check endpoint and restart it, if it times out
# dv this will need to be customized. But saved for now.
import requests
import json
import os
import logging
cs="restart_triplestore.sh" #fixed to _ once it is working
#cs="restart-triplestore.sh" #use during testing
url="https://graph.geodex.org/blazegraph/namespace/earthcube/sparql"
url2="http://graph.geocodes.earthcube.org"

logger = logging.getLogger(__name__)


def add2log(s):
   # date2log()
   # fs=f'[{s}]\n'
    #put_txtfile("log",fs,"a")
    logging.logging(s)

def os_system(cs):
    os.system(cs)
    add2log(cs)
#=
key =  "too/secret"
def add2slack(s):
    cs="curl -X POST -H ‘Content-type: application/json’ --data '{\"text\":{s}}' https://hooks.slack.com/services/{key}"
    os_system(cs)

def get_sc(url):
    logging.basicConfig(filename='app.log', filemode='a', format='%(name)s - %(levelname)s - %(message)s')
    try:
        print(f'checking:{url}')
        #rds=requests.post(url)
        rds=requests.get(url, timeout=(15, 45))
        #print(rds.json()) #check for good return before running the rest
        print(rds.status_code)
    #except:
    except Exception as e:
        print(cs)
        #add2log(cs)
        #add2log(e) #pass str
        #add2slack(e) #pass str
        os.system(cs) # restart

get_sc(url2)
