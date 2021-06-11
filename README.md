# BashScript-cPanel_Malicious_Process
Bash Script to find malicious process running under users and scan user home directories to remove code injections and malicious files.

## Description

This bash script is used to find the malicious process running under users on a [cPanel server](https://cpanel.net/). If the cPanel server is having many outdated [CMS](https://en.wikipedia.org/wiki/List_of_content_management_systems) websites, the chances are high for hackers to exploit vulnerabilites on the outdated softwares and cause issues on the website and servre. These malicious processes can cause high load on server and also affect multiple websites. In this script, we can use to find the malicious process running under users and stop them. Also, this script scan the files under the user accounts and remove first line injections and other malicious files.

## Features

- Finds malicious process under all users on server and can scan them using one script.
- Checks server load average and runs only if the load is below 5
- Checks total disk space of all user accounts found and asks for confirmation before scanning if the disk space to scan is high. (We can opt to scan users manually if the disk space to scan is very high)
- Removes injections and malicious files directly - no need to remove manually. 

## How to use

Please use the following steps to use this script,

```
# yum install git -y
# cd /usr/local/src/
# git clone https://github.com/MarkAntonyGit/BashScript-cPanel_Malicious_Process.git
# cd BashScript-cPanel_Malicious_Process
# sh MalprocKiller.sh
```

## Sample Screenshots

-- Script Outputs

![](https://github.com/MarkAntonyGit/MarkAntonyGit/blob/main/Uploads/Sample%20Screenshots/Malproc1.png)

![](https://github.com/MarkAntonyGit/MarkAntonyGit/blob/main/Uploads/Sample%20Screenshots/Malproc2.png)

-- Condition samples

![](https://github.com/MarkAntonyGit/MarkAntonyGit/blob/main/Uploads/Sample%20Screenshots/Malproc3.png)

![](https://github.com/MarkAntonyGit/MarkAntonyGit/blob/main/Uploads/Sample%20Screenshots/Malproc4.png)

### Connect with Me

--------<img src="https://img.shields.io/badge/-Mark%20Antony-brightgreen"/> ------------------------------------------------------------------------------------------------------------------------------- <a href="mailto:markantony.alenchery@gmail.com"><img src="https://img.shields.io/badge/-markantony.alenchery@gmail.com-D14836?style=flat&logo=Gmail&logoColor=white"/></a> --------------------- ---------------------------------------------------------------------------------- <a href="https://www.linkedin.com/in/profile-markantony/"><img src="https://img.shields.io/badge/-Linkedin-blue"/></a> ----------------------------------------------------

<p align="center">
<a href="mailto:markantony.alenchery@gmail.com"><img src="https://img.shields.io/badge/-markantony.alenchery@gmail.com-D14836?style=flat&logo=Gmail&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/mark-antony-345473211https://www.linkedin.com/in/mark-antony-345473211"><img src="https://img.shields.io/badge/-Linkedin-blue"/></a>
