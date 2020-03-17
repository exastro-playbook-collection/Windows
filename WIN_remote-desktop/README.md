# Ansible Role: Windows\WIN\_remote-desktop
=======================================================

## Description
本RoleではWindows Server 2016のリモートデスクトップの接続許可/不可に設定する。

## Supports  
- 管理マシン(Ansibleサーバ)  
 * Linux系OS（RHEL）  
 * Ansible バージョン 2.4 以上  
 * Python バージョン 2.7  
- 管理対象マシン(構築対象マシン)
 * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * AnsibleホストはターゲットホストへPowershell接続できる必要がある。
- 管理対象マシン(インストール対象マシン)
 * Windows Server 2016
 * Powershell3.0+

## Role Variables
Role の変数値について説明します。

### Mandatory variables
~~~
　  * VAR_WIN_remote_desktop_state                      # 指定管理対象マシンへのリモート接続を許可(enabled)/不可(disabled)に設定する。デフォルト値: "enabled"
　  * VAR_WIN_remote_desktop_modify_firewall_exception  # ファイアウォール例外（通信許可）を設定する(yes)/しない(no)。デフォルト値: yes
　  * VAR_WIN_remote_desktop_nla                        # ネットワークレベル認証でリモートデスクトップを実行しているコンピュータからのみ接続を許可する。
　                                                          # 有効(enabled)/無効(disabled)、デフォルト値: "enabled"
~~~

### Optional variables

特にありません。

## Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

リモートデスクトップを設定する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts/
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_remote-desktop
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       modify.yml
　  │                │       post_check.yml
　  │                └─ README.md
　  └─ win_remote-desktop.yml
~~~

- マスターPlaybook サンプル[win\_remote-desktop.yml]
~~~
#win_remote-desktop.yml
　  - name: win_remote-desktop setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_remote-desktop
　        VAR_WIN_remote_desktop_state: "enabled"
　        VAR_WIN_remote_desktop_modify_firewall_exception: yes
　        VAR_WIN_remote_desktop_nla: "enabled"
　      tags:
　        -WIN_remote-desktop
~~~

## Running Playbook

- リモートデスクトップを設定する時、以下のように実行する。    

~~~sh
> ansible-playbook win\_remote-desktop.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_remote\_desktop\_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/WIN_remote-desktop"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[win\_remote-desktop.yml]
~~~
　---
　  - import_playbook: win_remote_desktop_evidence.yml VAR_gathering_label=before
　  - name: win_remote-desktop setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_remote-desktop  
　        VAR_WIN_remote_desktop_state: "enabled"
　        VAR_WIN_remote_desktop_modify_firewall_exception: yes
　        VAR_WIN_remote_desktop_nla: "enabled"
　        tags: 
　           -WIN_remote-desktop
　 - import_playbook: win_remote_desktop_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0              # 管理対象マシンのリモート許可の状態
　    │   ├── 1              # ファイアウォール例外の状態
　    │   ├── 2              # ネットワークレベル認証要否の状態
　    │   └── results.json   # 各コマンドの情報を格納するJSONファイル
　    └── registry
　         └── HKLM
　             └── SYSTEM
　                 └── CurrentControlSet
　                     ├── Control
　                     │   └── Terminal\ Server
　                     │       ├── export.reg
　                     │       └── WinStations
　                     │           └── RDP-Tcp
　                     │               └── export.reg         # ネットワークレベル認証要否の状態
　                     └── Services
　                         └── SharedAccess
　                             └── Defaults
　                                 └── FirewallPolicy
　                                     └── FirewallRules
　                                         └── export.reg     # ファイアウォール例外の状態
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
