# Ansible Role: Windows\WIN\_AdminApprovalMode
=======================================================

## Description
本ロールは、Windows Server 2016 に管理者承認モードですべての管理者を実行するように設定を行います。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.7 以上
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

~~~
* VAR_WIN_AdminApprovalMode_EnableLUA: yes
                                          # 「管理者承認モードですべての管理者を実行する」を設定します。
                                          # 設定可能の値：no/yes(デフォルト値)
* VAR_WIN_AdminApprovalMode_reboot: false    # 設定後すぐに再起動するかどうかを指定します。
                                          # 設定可能の値：true/false(デフォルト値)
~~~

## Dependencies

Ansible Role: Windows\WIN\_reboot。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて設定します。
3. Playbookを実行します。

## Example Playbook

### ■エビデンスを取得しない場合の呼び出す方法

本ロールを"roles"ディレクトリに配置して、以下のようなPlaybookを作成してください。

- フォルダ構成

~~~
 - playbook/
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └──  WIN_AdminApprovalMode/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_playbook.yml
~~~

- マスターPlaybook サンプル[win\_playbook.yml]

~~~
#win_playbook.yml
---
- name: Run All Administrators in Admin Approval Mode
  hosts: win
  roles:
    - role: Windows/WIN_AdminApprovalMode
      VAR_WIN_AdminApprovalMode_EnableLUA: no
      VAR_WIN_AdminApprovalMode_reboot: true
      tags:
        - WIN_AdminApprovalMode
  # reboot
  post_tasks:
    - include_role:
          name: Windows/WIN_reboot
      when: WIN_reboot_required == true
~~~

## Running Playbook

~~~
> ansible-playbook win_playbook.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_AdminApprovalMode\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role:  gathering 
      VAR_gathering_definition_role_path: "roles/Windows/WIN_AdminApprovalMode"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_playbook.yml]

~~~
---
- import_playbook: win_AdminApprovalMode_evidence.yml VAR_gathering_label=before

- name: Run All Administrators in Admin Approval Mode
  hosts: win
  roles:
    - role: Windows/WIN_AdminApprovalMode
      VAR_WIN_AdminApprovalMode_EnableLUA: no
      VAR_WIN_AdminApprovalMode_reboot: true

  # reboot
  post_tasks:
    - include_role:
          name: Windows/WIN_reboot
      when: WIN_reboot_required == true

- import_playbook: win_AdminApprovalMode_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      # 管理者承認モードですべての管理者を実行することの設定情報
　    │   └── results.json                           # 各コマンドの情報を格納するJSONファイル
　    │
　    └── registry
            └── HKLM
                └── Software
                    └── Microsoft
                        └── Windows
                            └── CurrentVersion
                                └── Policies
                                    └── System
                                         └── export.reg
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
