# Ansible Role: Windows\WIN\_uac
=======================================================

## Description
本ロールは、Windows Server 2016 にUACの設定を行います。

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
* VAR_WIN_uac: 'middle'               # UAC設定のタイプ（レベル）を指定します。
                                          # 大小文字を区別しません。
                                          # 設定可能の値：
                                          # 下記通知のタイミングによりhigh1～4、middle、low、disabledを分類します。
                                          #  ・アプリがソフトウェアをインストールしようとする場合（highx）
                                          #  ・アプリがコンピューターに変更を加えようする場合（highx、middle、low）
                                          #  ・ユーザーがWindows設定を変更する場合（highx）
                                          #  ・通知しない（disabled）
                                          # 具体的な画面表示は以下の通り：
                                          #  ①high1： 安全なデスクトップに特権のあるユーザ名とパスワードを入力する必要
                                          #  ②high2： 安全なデスクトップに[はい]または[いいえ]を選択する必要
                                          #  ③high3： 安全なデスクトップなしで管理ユーザ名とパスワードを入力する必要
                                          #  ④high4： 安全なデスクトップなしで[はい]または[いいえ]を選択する必要
                                          #  ⑤middle（デフォルト値）： 安全なデスクトップに[はい]または[いいえ]を選択する必要
                                          #  ⑥low：安全なデスクトップなしで[はい]または[いいえ]を選択する必要
                                          #  ⑦disabled：通知しない、UAC無効
* VAR_WIN_uac_reboot: false           # 再起動するかどうかを指定します。
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
　  │          └──  WIN_uac/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_uac.yml
~~~

- マスターPlaybook サンプル[win\_uac.yml]

~~~
#win_uac.yml
---
- name: Windows UAC update
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/WIN_uac
      VAR_WIN_uac: 'disabled'
      VAR_WIN_uac_reboot: false
      tags:
        - WIN_uac
  # reboot
  post_tasks:
    - include_role:
          name: Windows/WIN_reboot
      when: WIN_reboot_required == true
~~~

## Running Playbook

~~~
> ansible-playbook win_uac.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_uac\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_uac"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_uac.yml]

~~~
---
- import_playbook: win_uac_evidence.yml VAR_gathering_label=before

- name: Windows UAC update
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/WIN_uac
      VAR_WIN_uac: 'disabled'
      VAR_WIN_uac_reboot: false
      tags:
        - WIN_uac

- import_playbook: win_uac_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      #　ConsentPromptBehaviorAdmin設定のレジストリ情報
　    │   ├── 1                                      #　PromptOnSecureDesktop設定のレジストリ情報
　    │   ├── 2                                      #　EnableLUA設定のレジストリ情報
　    │   └── results.json                           #　各コマンドの情報を格納するJSONファイル
　    │  
　    └── registry
　        └── HKLM
　            └── SOFTWARE
　                └── Microsoft
　                    └── Windows
　                        └── CurrentVersion
　                            └── Policies
                                  └──System
　                                   └── export.reg  # UAC設定のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
