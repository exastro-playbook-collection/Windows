# Ansible Role: Windows\WIN\_ProcessorScheduling
=======================================================

## Description
本ロールは、Windows Server 2016 にプロセッサのスケジュールの設定を行います。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.8.1
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
* VAR_WIN_ProcessorScheduling: program
　                              # Windows詳細情報の最適なパフォーマンスを指定します。大小文字を区別しません。
                                # 設定可能の値：
                                # ・ default (コンピューターに応じて最適なものを自動的に選択する)　→　デフォルト値
                                # ・ program (プログラムを優先する)
                                # ・ backgroundservice (バックグラウンドサービスを優先する)
~~~

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
　  │          └──  WIN_ProcessorScheduling/
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
- name: processScheduing setting
  hosts: win
  gather_facts: false
  roles:
  - role: WIN_ProcessorScheduling
    VAR_WIN_ProcessorScheduling: program
~~~

## Running Playbook

~~~
> ansible-playbook win_playbook.yml -i hosts
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_gathering_playbook.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "WIN_ProcessorScheduling"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_playbook.yml]

~~~
---
- import_playbook: win_gathering_playbook.yml VAR_gathering_label=before

- name: processScheduing setting
  hosts: win
  gather_facts: false
  roles:
  - role: WIN_ProcessorScheduling
    VAR_WIN_ProcessorScheduling: program

- import_playbook: win_gathering_playbook.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      # Windows詳細情報の最適なパフォーマンスの設定情報
　    │   └── results.json                           # 各コマンドの情報を格納するJSONファイル
　    │
　    └── registry
            └── HKLM
                └── SYSTEM
                    └── CurrentControlSet
                        └── Control
                            └── PriorityControl
                                └── export.reg
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

- ### 作成部門
NEC Advanced Software Technology(Beijing)Co.,Ltd.
Software Development Division
 1st Development Department

- ### 作成日
2019/12/12

- ### 更新日
2019/12/18
