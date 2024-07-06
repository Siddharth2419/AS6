#  Packer 

## Installation
Install from 
[install](https://developer.hashicorp.com/packer/install)
'''
unzip packer_1.11.1_linux_amd64.zip 
Archive:  packer_1.11.1_linux_amd64.zip
  inflating: LICENSE.txt             
  inflating: packer                  
siddharth@siddharth-Inspiron-5520:~/Downloads$ sudo mv packer /usr/local/bin/
siddharth@siddharth-Inspiron-5520:~/Downloads$ cd
siddharth@siddharth-Inspiron-5520:~$ packer version 


'''
[awsplugin](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon)
## Steps
* aws configure
* add credentials
* create new dir add json contains AMI []
  '''
  packer validate .json
  packer build .json
  '''
  ## You can use builder from official sites
