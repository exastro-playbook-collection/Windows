# Ansible Role: Windows\WIN\_user-rights-assign
=======================================================

## Description
このロールは、windows server 2016のユーザー権利を割り当てるために使用されます。

## Supports  
- 管理マシン(Ansibleサーバ)  
 * Linux系OS（RHEL）  
 * Ansible バージョン 2.7 以上  
 * Python バージョン 2.7  
- 管理対象マシン
 * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * Ansibleホストは管理対象マシントへPowershell接続できる必要がある。
- 管理対象マシン
 * Windows Server 2016
 * Powershell3.0+

## Role Variables
Role の変数値について説明します。

### Mandatory variables

~~~
* VAR_userRightsAssign_info:           # ユーザー権利の情報を設定します。（※複数の子項目を指定できること。）
    - name:                            # ユーザ権利の名前を指定します。必須項目、大小文字を区別しません。設定可能の値は下記の表１を参照してください。
      user:                            # ユーザ名を指定します。必須項目、大小文字を区別しません。複数値を設定できます。。
        - User1
        - User2
        - ・・・・・・
      action:                          # ユーザ権利に対して、操作（add/remove/set）を指定します。必須項目、大小文字を区別しません。
                                       # ・「add」は既存の権利にユーザー/グループを追加します。
                                       # ・「remove」は既存の権利からユーザー/グループを削除します。
                                       # ・「set」は既存の権利のユーザー/グループを置き換えます。
~~~

※ユーザー権利の割り当て（User Rights Assignment）について、以下の表１を参照してください。

| 番号 | 設定内容（日本語） | 設定内容（英語） | ユーザ権利の名前 | 
|---|---|---|---|
| 01 | オペレーティング システムの一部として機能 | Act as part of the operating system | SeTcbPrivilege |
| 02 | プロセスのメモリ クォータの増加 | Adjust memory quotas for a process | SeIncreaseQuotaPrivilege |
| 03 | 走査チェックのバイパス | Bypass traverse checking | SeChangeNotifyPrivilege |
| 04 | 認証後にクライアントを偽装 | Impersonate a client after authentication | SeImpersonatePrivilege |
| 05 | サービスとしてログオン | Log on as a service | SeServiceLogonRight |
| 06 | サービスとしてのログオンを拒否 | Deny log on as a service | SeDenyServiceLogonRight |
| 07 | 監査とセキュリティ ログの管理 | Manage auditing and security log | SeSecurityPrivilege |
| 08 | プロセス レベル トークンの置き換え | Replace a process level token | SeAssignPrimaryTokenPrivilege |

### Optional variables

特にありません。

## Dependencies

特にありません。

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
　  │          └── WIN_user-rights-assign/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_userrights_assign.yml
~~~

- マスターPlaybook サンプル[win\_userrights\_assign.yml]

~~~
#win_userrights_assign.yml
---
- name: Windows user rights assign playbook
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_user-rights-assign
      VAR_userRightsAssign_info:
        - name: SeTcbPrivilege
          user:
            - user1
            - user2
          action: add
        - name: SeIncreaseQuotaPrivilege
          user:
            - user3
          action: remove
        - name: SeChangeNotifyPrivilege
          user:
            - user1
            - user2
            - user3
          action: set
      tags:
        - WIN_user_rights_assign
~~~

## Running Playbook

~~~sh
> ansible-playbook win_userrights_assign.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_userrights\_assign_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_user-rights-assign"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_userrights\_assign.yml]

~~~
---
- import_playbook: win_userrights_assign_evidence.yml VAR_gathering_label=before

- name: Windows user rights assign playbook
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_user-rights-assign
      VAR_userRightsAssign_info:
        - name: SeTcbPrivilege
          user:
            - user1
            - user2
          action: add
        - name: SeIncreaseQuotaPrivilege
          user:
            - user3
          action: remove
        - name: SeChangeNotifyPrivilege
          user:
            - user1
            - user2
            - user3
          action: set

- import_playbook: win_userrights_assign_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                                      #　ユーザー権利の割当情報
　        ├── 1                                      #　グループと対応するSIDの情報
　        ├── 2                                      #　ユーザと対応するSIDの情報
　        └── results.json                           #　各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
