# Ansible Role: Windows\NEC\_WIN\_powershell-execution-policy
=======================================================

## Description
本ロールは、Windows Server 2016 にパワーシェル実行ポリシーの設定を行います。

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

~~~
* VAR_NEC_WIN_executionPolicy:               # パワーシェル実行ポリシーを設定します。
    - psexecpolicy: RemoteSigned             # パワーシェル実行ポリシー、大小文字を区別しません。
                                             # 設定できる値：Restricted、AllSigned、RemoteSigned、Unrestricted、Bypass、Undefined
~~~

### Optional variables

~~~
* VAR_NEC_WIN_executionPolicy:               # パワーシェル実行ポリシーを設定します。
    - psscope: LocalMachine                  # 設定対象、大小文字を区別しません。
                                             # 設定できる値：CurrentUser、LocalMachine（デフォルト値）
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
　  │          └── NEC_WIN_powershell-execution-policy/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │       modify.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_psexecpolicy.yml
~~~

- マスターPlaybook サンプル[win\_psexecpolicy.yml]

~~~
#win_psexecpolicy.yml
---
- name: set powershell's execution policy
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/NEC_WIN_powershell-execution-policy
      VAR_NEC_WIN_executionPolicy：
        - psexecpolicy: RemoteSigned
          psscope: LocalMachine
        - psexecpolicy: RemoteSigned
          psscope: CurrentUser
      tags:
        - NEC_WIN_powershell-execution-policy
~~~

## Running Playbook

~~~
> ansible-playbook win_psexecpolicy.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_psexecpolicy\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_powershell-execution-policy"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_psexecpolicy.yml]

~~~
---
- import_playbook: win_psexecpolicy_evidence.yml VAR_gathering_label=before

- name: set powershell's execution policy
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/NEC_WIN_powershell-execution-policy
      VAR_NEC_WIN_executionPolicy：
        - psexecpolicy: RemoteSigned
          psscope: LocalMachine
        - psexecpolicy: RemoteSigned
          psscope: CurrentUser

- import_playbook: win_psexecpolicy_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                               #　パワーシェル実行ポリシー
　        └── results.json                    #　コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
