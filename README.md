# ansible

### create vault
```shell
ansible-vault create secret
```

### vault data
```yaml
user_password: qwerty12345
user: admin
ovpn_port: 5671
wg_port: 6734
tg_token: qwerty12345
tg_chat: -12345
root_password: qwerty12345
seed: "super gread seed for key"
```

#### Add external repo app
```yml
---
- name: Install GPG key
  when: enable_newrelic
  apt_key:
    url: http://download.newrelic.com/548C16BF.gpg
    state: present
  register: gpg_key_installed

- name: Add New Relic apt repository
  when: gpg_key_installed|succeeded
  copy:
    content: "deb http://apt.newrelic.com/debian/ newrelic non-free"
    dest: /etc/apt/sources.list.d/newrelic.list
  register: newrelic_repo_installed

- name: Install New Relic system monitor
  when: newrelic_repo_installed|succeeded
  apt:
    name: newrelic-sysmond
    state: latest
    update_cache: yes
  register: newrelic_installed

- name: Configure New Relic license key
  when: newrelic_installed|succeeded
  command: nrsysmond-config --set license_key={{ newrelic_license_key }}
  notify: start newrelic
```