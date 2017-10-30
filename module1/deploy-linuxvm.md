# A Very Simple Deployment of a Linux VM through the Portal #
We're going to use the Azure portal to deploy a linux VM for the later exercises. 

## Create the Linux VM
1. Log into the Azure Portal at http://portal.azure.com
2. Click on the "+" in the upper right, then click on 'Compute', then select "Ubuntu 16.04" | "Ubuntu Server 16.04 LTS", and on the next page, click 'Create'.
3. On the basics page, fill in the following:
    1. **Name:** 
    2. **Username:**    
    3. **Authentication Type:** 
    4. **Password:**   
    5. **Resource Group:**

    Then click 'OK'

4. On the next page, choose your machine size.  Since we're not doing anything fancy on this linuxVM, a DS1_V2 is fine.
3. On the 'Settings' page, just click 'OK'
4. Finally, on the 'Summary' page, review the settings, then click 'OK'

At this point, your linux VM will begin to deploy.   This may take a minute or two.

Once your VM has deployed, take a look at the Overview page.  Click on the 'Connect' button at the top to get the ssh command to remotely log into your Linux VM.

> On Windows and need SSH? Try either [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) or  [Bitvise SSH](https://www.bitvise.com/ssh-client-download)

## Connect to the Linux VM
From your laptop, ssh into the Linux VM.

## Install the Azure cli
1. First, you need to install some prereqs.
```
sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
```
2. Next, install the cli
```
curl -L https://aka.ms/InstallAzureCli | bash
```

The cli is now installed!

Finally, configure the output to default to table format.  Run:
```
az configure
```
and follow the prompts to select 'table' as the default output.

## Connect to your subscription from the Azure CLI

Here is how to login interactively from your web browser:
[Log in with Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli#interactive-log-in)

Once the command shell completes the log in process, confirm you're logged in by running:

```
az account list
```