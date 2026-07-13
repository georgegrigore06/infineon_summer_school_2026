# Infineon summmer school for IP Design and IP Functional Verification

## How to

### Run IP simulation:

This repository uses a simple wrapper script named _**run.sh**_ for composing the required _xrun_ command.
Below you will find an example for staritng a testbench named _**sandbox**_ in GUI and batch mode.

- GUI simulation:
```bash
cd simulation/rtl_sim
./run.sh sandbox gui  # runs the testbench named sanbox in visual GUI mode, needs active VNC connection
                      # or properly configured ssh_config and active X11 server on the local machine
```
- Batch simulation:
```bash
cd simulation/rtl_sim
./run.sh sandbox batch # runs the testbench named sandbox in console mode. Usefull for compilation checks
                       # and non visual debug (i.e. debbug using log messages)
```

- Clean simulation artifacts:
``` bash
make clean
```

### Run IP simulation using UVM methodology (for functional verification)

This repository uses a simple python script for composing the required _xrun_ command.
Below you will find an example for starting a UVM test called _**sandbox**_ in GUI and batch mode.

- GUI simulation:
```bash
cd simulation/sv_sim
# Clean previous artifactis and start the sandbox test with seed 1234 
./run.py -mode sim -test sandbox -seed 1234 -clean 
```

- Batch simulation:
```bash
cd simulation/sv_sim
# Clean previous artifactis and start the sandbox test with seed 1234 
./run.py -batch -mode sim -test sandbox -seed 1234 -clean
```

### Run test coverage analysis 
- Open tool:
``` bash
cd simulation/sv_sim
./run.py -mode imc 
```
- Choose the required database by clicking _**Open Database**_ and navigate </br>
to the folder where database is located (usually should be inside the sv_sim folder)

## FAQ:
1. I cannot run the `run.sh` script. How do I fix this ?
Run `chmod +x run.sh` and try again.
2. I cannot run  the `run.py` script. How do I fix this ?
Run `chmod +x run.py` and try again
3. I am using VNC connection and simulator GUI does not open. What can I do ?
- [ ] Check for compilation errors using the console or the `xrun.log` file.    
- [ ] If there are no errors, make sure that the command requested GUI mode.
4. I am using Xserver on my local machine and the GUI does not oper. What can I do ?
- [ ] Check for compilation errors using the console or the `xrun.log` file.
- [ ] If there are no compilation erros, make sure the local Xserver is running on your machine.
- [ ] If the local server (i.e. Xlaunch/Xming) is started, run `bash echo $DIPLAY #a value should be displayed `.
- [ ] If no value is displayed when running the command above. Check that your `ssh_config` allows for X11 Forwarding/
- [ ] If this also fails, switch to using VNC Connection.
5. My VNC connection was terminated and I cannot reconnect. What do I do ?
- From your active VsCode ssh connection open a console and run.
``` bash
pkill -u <your_user_name> # Terminate all processes spawned by your user
```
- Reconnect your VsCode and VNC session