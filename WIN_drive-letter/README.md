# Ansible Role: Windows\WIN\_drive-letter
=======================================================

## Description
本ロールは、Windows Server 2016 に ドライブレターの変更を行います。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.7 以上 (動作確認バージョン 2.7, 2.9)
  * Python バージョン 2.x, 3.x  (動作確認バージョン 2.7, 3.6)
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
* VAR_WIN_DriveLetter_info:     # ドライブレター設定情報を指定します。子項目は繰り返して設定できます。
    - originalName: F               # 変更元のドライブレターを指定します。必須項目、大小文字を区別しません。
                                    # 【制限事項】OSシステムが存在しているディスクのドライブレターを変更できません。
      assignName: H                 # 変更先のドライブレターを指定します。必須項目、大小文字を区別しません。
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
　  │          └──  WIN_drive-letter/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │       set.yml
　  │                │── templates/
　  │                │       assignDrive.j2
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_playbook.yml
~~~

- マスターPlaybook サンプル[win\_playbook.yml]

~~~
#win_playbook.yml
---
- name: Drive letter setting
  hosts: win
  roles:
    - role: Windows/WIN_drive-letter
      VAR_WIN_DriveLetter_info: 
        - originalName: D
          assignName: H
        - originalName: E
          assignName: M
      tags:
        - WIN_drive-letter
~~~

## Running Playbook

~~~
> ansible-playbook win_playbook.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_driveLetter\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_drive-letter"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_playbook.yml]

~~~
---
- import_playbook: win_driveLetter_evidence.yml VAR_gathering_label=before

- name: Drive letter setting
  hosts: win
  roles:
    - role: Windows/WIN_drive-letter
      VAR_WIN_DriveLetter_info: 
        - originalName: D
          assignName: H
        - originalName: E
          assignName: M

- import_playbook: win_driveLetter_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                                      # 管理対象マシン上のすべてのドライブ文字の情報
　        └── results.json                           # 各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
