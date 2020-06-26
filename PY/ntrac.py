import sys,requests,logging
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from xml.etree import ElementTree as ET


strLogPath = "c:\\temp"
strFileName = "\\ntrac"


logging.basicConfig(level=logging.DEBUG, 
  format="%(asctime)s %(levelname)s %(thread)d %(funcName)s %(message)s",
  handlers=[
    logging.FileHandler("{0}/{1}.log".format(strLogPath, strFileName)),
    logging.StreamHandler()
  ])


try:
    ip = str(sys.argv[1])
    user = str(sys.argv[2])
    pwd = str(sys.argv[3])
    cmd = str(sys.argv[4])
    verbose = int(sys.argv[5])
except:
    print("--> usage: python ntrac.py 192.168.0.1 root calvin getsysinfo [0|1 verbose flag]")
    sys.exit(1)

    
BASE_URI = "https://" + ip
headers = {"User-Agent": "SSLClient"}
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)


def discover(ip=ip):
    global BASE_URI
    global headers
    resp = requests.get(BASE_URI + "/cgi-bin/discover", verify=False, headers=headers, auth=False)
    if verbose != 0:
        print("*" * 70 + "\nDISCOVER\n" + "*" * 70)
        print("ReCode: %d\nHeaders:\n%s\nPayload:\n%s\n" % (resp.status_code, resp.headers, resp.text))
    
    
def login(ip=ip, user=user, pwd=pwd):
    global BASE_URI
    global headers
    payload = "<xml version='1.0'?><LOGIN><REQ><USERNAME>%s</USERNAME><PASSWORD>%s</PASSWORD></REQ></LOGIN>" % (user, pwd)
    resp = requests.post(BASE_URI + "/cgi-bin/login", verify=False, headers=headers, data=payload, auth=False)
    dom = ET.fromstring(resp.text)
    sid = dom[0].find("SID").text
    if verbose != 0:
        print("*" * 70 + "\nLOGIN\n" + "*" * 70)
        print("ReCode: %d\nHeaders:\n%s\nPayload:\n%s\n" % (resp.status_code, resp.headers, resp.text))
        print("SID: %s\n" % sid)
    return sid

    
def cmdexec(sid, cmd, ip=ip, user=user, pwd=pwd):
    global BASE_URI
    global headers
    cookie = {"sid": sid, "path" : "/cgi-bin/", "host" : ip}
    payload = "<?xml version='1.0'?><EXEC><REQ><CMDINPUT>racadm %s</CMDINPUT><MAXOUTPUTLEN>0x0fff</MAXOUTPUTLEN><CAPABILITY>0x1</CAPABILITY></REQ></EXEC>" % cmd
    resp = requests.post(BASE_URI + "/cgi-bin/exec", verify=False, cookies=cookie, headers=headers, data=payload, auth=False)
    dom = ET.fromstring(resp.text)
    data = dom[0].find("CMDOUTPUT").text
    if verbose != 0:
        print("*" * 70 + "\nCMD EXEC\n" + "*" * 70)
        print("ReCode: %d\nHeaders:\n%s\nPayload:\n%s\n" % (resp.status_code, resp.headers, resp.text))
    return data

    
def logout(sid, ip=ip, user=user, pwd=pwd):
    global BASE_URI
    global headers
    cookie = {"sid": sid, "path" : "/cgi-bin/", "host" : ip}
    headers.update({"Connection": "Close"})
    resp = requests.get(BASE_URI + "/cgi-bin/logout", verify=False, cookies=cookie, headers=headers, auth=False)
    if verbose != 0:
        print("*" * 70 + "\nLOGOUT\n" + "*" * 70)
        print("ReCode: %d\nHeaders:\n%s\nPayload:\n%s\n" % (resp.status_code, resp.headers, resp.text))
    

def main():
    discover()
    cookie = login()
    output = cmdexec(cookie, cmd)
    logout(cookie)
    if verbose == 0:
        print(output)
    
    
if __name__ == '__main__':
    main()