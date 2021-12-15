# AADevOpsChallenge

This is pretty simple to run, if you meet the prerequiites<br>
<br>
Prerequisites:<br>
.-an aws account<br>
.-a configured installation of aws cli<br>
  to install and configure aws cli, you can follow amazon's documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html<br>
.-terraform<br>
  to install terraform, you can follow HashiCorp's documentation here: https://learn.hashicorp.com/tutorials/terraform/install-cli<br>
<br>
Once you've met these three requirements you are ready!<br>
<br>
I'll assume that if you're browsing github you know your way around the command line interface<br>
<br>
Step 1:<br>
  Clone the repo<br>
Step 2:<br>
  Open a terminal in the directory where you cloned the repo.<br>
Step 3:<br>
  Make sure your 'default' profile in aws cli is able to create infrastructure, the terraform script will create more than a dozen resources, including a VPC,<br>
  an autoscaling group, a load balancer and an internet gateway, among others.<br>
Step 4:<br>
  Create a key pair in aws ec2 (you can use the aws management console if you don't feel like using the cli) and make sure you name it "AAChallenge" (without<br>   quotes). 
  in the future the key name will be variable, but for now just name it that.<br>
  You don't need to ssh into your instances to run this, but if you want to modify something, it will be useful for troubleshooting.<br>
Step 5:<br>
  In the terminal you opened in step 2, run terraform init, this will install the aws provider.<br>
 Step 6:<br>
   Still in the terminal, run terraform apply<br>
   terraform will display a plan of what it will do before asking you for confirmation, when asked to, type 'yes' so that terraform will begin creating your <br>
   infrastructure.<br>
 Step 7:<br>
   Now go to the aws management console (https://console.aws.amazon.com/) and log in.<br>
 Step 8:<br>
   make sure you are in region US West (N. California) a.k.a. us-west-1 and in the search box type 'load balancers', when the results display, make sure you <br>
   select the one from EC2 and not the lightsail one.<br>
 step 9:<br>
   if you have more than one load balancer look for the one with the tag "Name" with value "AAAppLB", and int the tab labeled "Description" find the DNS name, <br>
   and copy it<br>
 step 10:<br>
   in your web browser of choice, paste the dns name into the address bar and hit enter.<br>
   tou will be ewlcomed by a dialog box asking for a username.<br>
 <br>
 and youŕe done!<br>
