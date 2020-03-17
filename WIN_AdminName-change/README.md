# Ansible Role: Windows\WIN\_AdminName-change
=======================================================

## Description
本ロールは、Windows Server 2016 に Administrator アカウント名の変更を行います。

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
* VAR_WIN_AdminName: admin            # Administrator アカウント名を設定します。
                                          # デフォルト値：Administrator
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
　  │          └──  WIN_AdminName-change/
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
- name: change the administrator name
  hosts: win
  roles:
    - role: Windows/WIN_AdminName-change
      VAR_WIN_AdminName: admin
      tags:
        - WIN_AdminName-change
~~~

## Running Playbook

~~~
> ansible-playbook win_playbook.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_AdminNameChange\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_AdminName-change"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_playbook.yml]

~~~
---
- import_playbook: win_AdminNameChange_evidence.yml VAR_gathering_label=before

- name: change the administrator name
  hosts: win
  roles:
    - role: Windows/WIN_AdminName-change
      VAR_WIN_AdminName: admin
      tags:
        - WIN_AdminName-change

- import_playbook: win_AdminNameChange_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                                      # 全てのユーザのアカウント情報
　        ├── 1                                      # Administrator アカウント名を含むiniファイルを出力
　        ├── 2                                      # 上記iniファイルの内容を表示
　        ├── 3                                      # 最後は当該iniファイルを削除
　        └── results.json                           # 各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
