### Build Name: User_Management


**Purpose:**   To Create/Delete/Modify Linux shell user  on servers.

**User Inputs to pass:**

1. Task(create/delete) for user
2. Remote server ip
3. Remote server login details(ssh user/login_key/ssh_port)  
4. User name to add/delete
5. Boolean box to check if user requires sudo access.


**Pipeline  description stage wise below:**

1. clear workspace
--> Clears the workspace for the build

2. Clone all the git files
--> Clone  ssh-key and user-management projects (contains all the required  files to execute the build) on jenkins server.

3. Upload files to ansible
--> upload the required files from jenkins server to ansible server

4. Upload the ssh key
--> Upload ssh key if user is been created .

5. Create ansible host file
--> Custorm ansible host file contains host and its ssh login info on which user is to be created(using user inputs)  

6. Check SSH Connection
--> Verify the ssh creds to be valid or not(using user inputs)

7. Approve
--> User Approval to proceed with the build

8. Create user
--> Create the user on the respective server

9. Delete User
--> Delete the user on the respective server
