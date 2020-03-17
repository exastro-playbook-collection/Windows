# Ansible Role: Windows\WIN\_reboot
=======================================================

## Description
本ロールは、Windows Server 2016 のサーバ再起動を行います。  
以下の用途で使用することができます。
* 単独で再起動を行いたい場合
* 複数のロールを呼び出し、それぞれで再起動が必要になる可能性があるが、再起動は最後に一度だけ行えば良い場合

なお、Ansible 2.1からwin_rebootモジュールが提供されたため、単独再起動の場合は、本ロールは使用せず[win_reboot モジュール](https://docs.ansible.com/ansible/latest/modules/win_reboot_module.html#win-reboot-module)をご利用ください。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.4 以上
  * Python バージョン 2.7
- 管理対象マシン
  * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
  * Ansibleサーバは管理対象マシンへPowershell接続できる必要があります。
- 管理対象マシン
  * Windows Server 2016
  * Powershell3.0+

## Role Variables
ロールの変数について説明します。

### Mandatory variables

特にありません。

### Optional variables

単独再起動の場合、特に変数を設定する必要はありません。  
複数ロール間で再起動を制御する場合、以下の2つの変数を利用します。  

|変数名|意味|
|---|---|
|`VAR_<設定ロール名>_reboot`|各設定ロール内で処理後すぐ再起動させるかを設定する変数(Playbookで設定)|
|`WIN_reboot_required`|後続のタスクで再起動が必要かを設定する変数(各設定ロールで設定)|

　**※具体的な使い方は「複数ロール間で再起動を制御する方法」を参照してください。**  

## Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて設定します。
3. Playbookを実行します。

## Example Playbook

### ■単独で再起動を行う方法

本ロールを"roles"ディレクトリに配置して、以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_reboot
　  │                │── handlers
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                └─ README.md
　  └─ win_reboot.yml
~~~

- マスターPlaybook サンプル[win\_reboot.yml]
    ~~~
    #win_reboot.yml
      - name: Windows reboot
        hosts: win
        gather_facts: false
        roles:
          - role: Windows/WIN_reboot
    ~~~

### Running Playbook
~~~sh
> ansible-playbook win_reboot.yml
~~~

### ■複数ロール間で再起動を制御する方法

本ロールを"roles"ディレクトリに配置して、以下のようなPlaybookを作成してください。

- フォルダ構成（2つの設定ロール`WIN_test1`/`WIN_test2`とともに使用する例）
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          │── WIN_test1
　  │          │     │── meta
　  │          │     │       main.yml
　  │          │     │── tasks
　  │          │     │       main.yml
　  │          │     └─ README.md
　  │          │── WIN_test2
　  │          │     │── meta
　  │          │     │       main.yml
　  │          │     │── tasks
　  │          │     │       main.yml
　  │          │     └─ README.md
　  │          └── WIN_reboot
　  │                │── handlers
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                └─ README.md
　  └─ win_test.yml
~~~

- `WIN_test1/meta/main.yml` と `WIN_test2/meta/main.yml`
    ~~~
    ---
    #meta
        dependencies:
          - {role: WIN_reboot, WIN_reboot_nop: yes }
    ~~~

- `WIN_test1/task/main.yml` と `WIN_test2/task/main.yml`
    ~~~
    ---
    #Windows test
      # rebootロールの内部用変数を初期化
      - set_fact:
            WIN_reboot_required: "{{ WIN_reboot_required | d(false) }}"

      # ロールWIN_test1/WIN_test2の処理
      - name: processing of test role
        #
        # 実際の処理を記載
        #
        register: notify_ret

      # 本ロールの処理により再起動を行うかどうかを判断
      - name: notify handlers
        raw: echo "Reboot ..."
        notify:
          - Run reboot command
          - Wait for connection down
          - Wait for connection up
        when:
          - notify_ret | changed
          - VAR_WIN_test1_reboot == true        # WIN_test1の場合の例

      # 上記のnotify handlers処理が実施された場合はここでhandlerを実行する
      - meta: flush_handlers

      # 本ロールの処理で再起動の必要あり、かつ、再起動を実施しない場合は、
      # 変数WIN_reboot_requiredをtrueに設定し、以後のrole/playbookに任せる
      - name: changed required value
        set_fact:                                   # WIN_test1の場合の例
            WIN_reboot_required: "{{ not VAR_WIN_test1_reboot }}"
        when: notify_ret is changed
    ~~~

- win_test.yml
    ~~~
    ---
      - name: Windows test
        hosts: win
        gather_facts: false
        roles:                                # 必要なロールを順次呼び出し、最後にpost_tasksで再起動を実施する例
          - role: Windows/WIN_test1
            VAR_WIN_test1_reboot: false   # ロールWIN_test1の処理後、再起動をしない例のためfalseに設定
          - role: Windows/WIN_test2
            VAR_WIN_test2_reboot: false   # ロールWIN_test2の処理後、再起動をしない例のためfalseに設定
        # reboot
        post_tasks:
          - include_role:
                name: Windows/WIN_reboot
            when: WIN_reboot_required == true
    ~~~

## Running Playbook
~~~sh
> ansible-playbook win_test.yml
~~~

## License

## Copyright

Copyright (c) 2017-2019 NEC Corporation

## Author Information

NEC Corporation
