iDRAC 2.70.70.70 now includes “keyboard interactive authentication” which will need to be handled by the SSH Client. 

http://docs.paramiko.org/en/2.6/api/transport.html
  - auth_interactive_dumb
  - is_authenticated 
  
```python
import paramiko,sys,time


hostname = sys.argv[1]
username = sys.argv[2]
password = sys.argv[3]
max_buffer = 65535

print("{} {} {}".format(hostname, username, password))


def clear_buffer(connection):
    if connection.recv_ready():
        return connection.recv(max_buffer)
		
def main():
	connection = paramiko.SSHClient()
	connection.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	connection.connect(hostname, username=username, password=password, look_for_keys=False, allow_agent=False)
	transport = connection.get_transport()
	if not transport.is_authenticated():
		transport.auth_interactive_dumb(username,handler=None,submethods="")
	#import pdb; pdb.set_trace()
	
	new_con = connection.invoke_shell()
	output = clear_buffer(new_con)
	time.sleep(2)
	
	commands = ['racadm getsysinfo -d\n']
	for cmd in commands:
		print("[%] processing {}".format(cmd))
		new_con.send(cmd)
		time.sleep(15)
		output = new_con.recv(max_buffer)
		print(str(output, 'UTF-8'))
	new_con.close()
	

if __name__ == "__main__":
	main()
```