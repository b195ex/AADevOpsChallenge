# AADevOpsChallenge

This is pretty simple to run, if you meet the prerequiites

Prerequisites:
.-an aws account
.-a configured installation of aws cli
  to install and configure aws cli, you can follow amazon's documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
.-terraform
  to install terraform, you can follow HashiCorp's documentation here: https://learn.hashicorp.com/tutorials/terraform/install-cli

Once you've met these three requirements you are ready!

I'll assume that if you're browsing github you know your way around the command line interface

Step 1:
  Clone the repo<br>
Step 2:
  Open a terminal in the directory where you cloned the repo.
Step 3:
  Make sure your 'default' profile in aws cli is able to create infrastructure, the terraform script will create more than a dozen resources, including a VPC,
  an autoscaling group, a load balancer and an internet gateway, among others.
Step 4:
  Create a key pair in aws ec2 (you can use the aws management console if you don't feel like using the cli) and make sure you name it "AAChallenge" (without quotes), 
  in the future the key name will be variable, but for now just name ita that.
  You don't need to ssh into your instances to run this, but if you want to modify something, it will be useful for troubleshooting.
Step 5:
  In the terminal you opened in step 2, run terraform init, this will install the aws provider.
 Step 6:
   Still in the terminal, run terraform apply
   terraform will display a plan of what it will do before asking you for confirmation, when asked to, type 'yes' so that terraform will begin creating your 
   infrastructure.
 Step 7:
   Now go to the aws management console (https://console.aws.amazon.com/) and log in.
 Step 8:
   make sure you are in region US West (N. California) a.k.a. us-west-1 and in the search box type 'load balancers', when the results display, make sure you 
   select the one from EC2 and not the lightsail one.
 step 9:
   if you have more than one load balancer look for the one with the tag "Name" with value "AAAppLB", and int the tab labeled "Description" find the DNS name, 
   and copy it
 step 10:
   in your web browser of choice, paste the dns name into the address bar and hit enter.
   tou will be ewlcomed by a dialog box asking for a username.
 
 and youŕe done!
