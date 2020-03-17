# Ansible Role: Windows\WIN\_error-report
=======================================================

## Description
本ロールは、Windows Server 2016 にエラー報告の設定を行います。

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
* VAR_WIN_errorreport: enabled             # エラー報告の状態を設定します。大小文字を区別しません。
                                               # 設定可能な値：enabled：エラー報告を有効にする、disabled：エラー報告を無効にする。
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
　  │          └── WIN_error-report/
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
　  └─ win_error-report.yml
~~~

- マスターPlaybook サンプル[win\_error-report.yml]

~~~
#win_error-report.yml
---
- name: set error reporting
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_error-report
      VAR_WIN_errorreport: Enable
      tags:
        - WIN_error-report
~~~

### Running Playbook

~~~
> ansible-playbook win_error-report.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_error-report\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_error-report"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win_error-report.yml]

~~~
---
- import_playbook: win_error-report_evidence.yml VAR_gathering_label=before

- name: set error reporting
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_error-report
      VAR_WIN_errorreport: Enable
      tags:
        - WIN_error-report

- import_playbook: win_error-report_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                               #　エラー報告の設定状態
　        └── results.json                    #　コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
