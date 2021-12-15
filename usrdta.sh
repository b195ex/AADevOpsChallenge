#!/bin/bash
cat > ~/playbook.yml << EOF
---
- name: Deploy Chat App
  hosts: localhost
  
  vars: 
      git_repo_url: https://github.com/b195ex/Chat-App-using-Socket.io.git
      repo_path: ~/repo
      repo_branch: master

  tasks:
  - name: upgrade all packages
    yum: 
      pkg: '*' 
      state: latest
  
  - name: installing git
    yum: 
      pkg: ['git']
      state: latest

  - name: installing nginx
    ansible.builtin.shell:
      cmd: amazon-linux-extras install nginx1

  - name: write custom.conf
    ansible.builtin.copy:
      content: 'location / { proxy_pass http://127.0.0.1:5000; }'
      dest: /etc/nginx/default.d/custom.conf

  - name: restart nginx
    ansible.builtin.shell:
      cmd: systemctl restart nginx

  - name: Clone the repo
    git:
      repo: "{{ git_repo_url }}"
      dest: "{{ repo_path }}"
      version: "{{ repo_branch }}"
      accept_hostkey: yes

  - name: Install packages based on package.json using the npm
    npm:
      path: "{{ repo_path }}"
      state: present
  
  - name: Install forever
    npm: 
      name: forever 
      global: yes 
      state: present

  - name: Check list of Node.js apps running
    command: forever list
    register: forever_list
    changed_when: false

  - name: Start Node.js app
    command: forever start ~/repo/app.js
    when: "forever_list.stdout.find('~/repo/app.js') == -1"
EOF
touch ~/.bashrc # this ensure the bashrc file is created
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source ~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node
cat <<EOF >> ~/.bashrc
export NVM_DIR="/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
cat <<EOF >> /home/ec2-user/.bashrc
export NVM_DIR="/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
sudo amazon-linux-extras install ansible2
ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 ~/playbook.yml
#node ~/repo/app.js &