# Ansible Role: Windows\NEC\_WIN\_owner-organization
=======================================================

## Description
本ロールは、Windows Server 2016 に組織と所有者の設定を行います。

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
* VAR_NEC_WIN_owner: User001                   # 設定したい所有者を指定します。（最大長256文字の文字列）
                                               # 空文字列も指定できます。すでに存在するものを消したい場合は、空文字列を指定してください。
                                               # 当該パラメータを定義されない場合、設定しません。
* VAR_NEC_WIN_organization: Organization001    # 設定したい組織を指定します。（最大長256文字の文字列）
                                               # 空文字列も指定できます。すでに存在するものを消したい場合は、空文字列を指定してください。
                                               # 当該パラメータを定義されない場合、設定しません。
~~~

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
　  │          └── NEC_WIN_owner-organization/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │       modify_organization.yml
　  │                │       modify_owner.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_owner-organization.yml
~~~

- マスターPlaybook サンプル[win\_owner-organization.yml]

~~~
#win_owner-organization.yml
---
- name: owner and organization setting
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/NEC_WIN_owner-organization
      VAR_NEC_WIN_owner: User001
      VAR_NEC_WIN_organization: Organization001
      tags:
        - NEC_WIN_owner-organization
~~~

### Running Playbook

~~~
> ansible-playbook win_owner-organization.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_owner-organization_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_owner-organization"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win_owner-organization.yml]

~~~
---
- import_playbook: win_owner-organization_evidence.yml VAR_gathering_label=before

- name: owner and organization setting
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/NEC_WIN_owner-organization
      VAR_NEC_WIN_owner: User001
      VAR_NEC_WIN_organization: Organization001
      tags:
        - NEC_WIN_owner-organization

- import_playbook: win_owner-organization_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
     ├── command
     │   ├── 0                               #　使用者情報（６４ビート）
     │   ├── 1                               #　使用者情報（３２ビート）
     │   ├── 2                               #　組織情報（６４ビート）
     │   ├── 3                               #　組織情報（３２ビート）
     │   └── results.json                    #　各コマンドの情報を格納するJSONファイル
     └── registry
            └── HKLM
                └── SOFTWARE
                    ├── Microsoft
                    │       └── Windows NT
      	            │		          └── CurrentVersion          #　使用者と組織のレジストリ情報など（６４ビート）
                    └── Wow6432Node
                            └── Microsoft
                                      └── Windows NT
                                             └── CurrentVersion   #　使用者と組織のレジストリ情報など（３２ビート）
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
