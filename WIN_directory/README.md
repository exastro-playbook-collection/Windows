# Ansible Role: Windows\WIN\_directory
=======================================================

## Description
本ロールは、Windows Server 2016 にディレクトリの作成と権限の設定を行います。

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
* VAR_WIN_directory: C:\temp\abc     # 作成するディレクトリ（フルパス）を指定します。
~~~

### Optional variables
~~~
* VAR_WIN_owner:                     # ディレクトリの所有者を設定します。
      user: Guest01                      # ディレクトリの所有者（ユーザ）
      recurse: false                     # 所有者を再帰的に変更するかどうか
                                         # true/false(デフォルト値)
* VAR_WIN_acl:                       # 指定されたディレクトリ対して、ユーザ、またはグループのアクセス権限を追加します。
    - user: Guest02                      # 使用者（ユーザやグループ）
      rights:                            # ディレクトリのアクセス権限、大小文字を区別しません。
        - delete                         # （例）削除権限
        - write                          # （例）書き権限
                                         # 設定可能な権限は ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, 
                                         #   ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, 
                                         #   DeleteSubdirectoriesAndFiles, ReadAttributes, WriteAttributes, Write, Delete, 
                                         #   ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership, 
                                         #   Synchronize, FullControl
      type: Allow                        # 指定した権限を許可または拒否するかどうか
                                         # allow：許可/deny：拒否
      state: present                     # 指定したアクセス規則を追加または無効にするかどうか
                                         # absent：無効化/present：追加（デフォルト値）
      inherit: ContainerInherit          # ACE（アクセス制御エントリ）規則のフラグを継承するかどうか
                                         # 大小文字を区別しません。
                                         #  ・ContainerInherit：ACEは子コンテナオブジェクトに継承され
                                         #  ・None：ACEは子オブジェクトに継承されない（デフォルト値）
                                         #  ・ObjectInherit：ACEはチャイルドリーフオブジェクトに継承され
      propagation: InheritOnly           # ACL規則の伝播フラグ
                                         # 大小文字を区別しません。
                                         #  ・InheritOnly：ACEは子オブジェクトにのみ伝播されます。これはコンテナとリーフの両方の子オブジェクトを含めます。
                                         #  ・None：継承フラグは設定されません。（デフォルト値）
                                         #  ・NoPropagateInherit：ACEは子オブジェクトに伝播されません。
~~~

## Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて設定します。
3. Playbookを実行します。

## Example Playbook

### ■呼び出す方法

本ロールを"roles"ディレクトリに配置して、以下のようなPlaybookを作成してください。

- フォルダ構成

~~~
 - playbook/
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_directory/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── files/
　  │                │       checkdir.ps1
　  │                │       execCMD.bat
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │       check.yml
　  │                │       modify.yml
　  │                │── vars/
　  │                │       main.yml
　  │                └─ README.md
　  └─ win_directory.yml
~~~

- マスターPlaybook サンプル[win\_directory.yml]

~~~
#win_directory.yml
---
- name: directory's creating and setting
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_directory
      VAR_WIN_directory: C:\temp\abc
      VAR_WIN_owner:  
          user: Guest01
          recurse: false
      VAR_WIN_acl:
        - user: Guest02
          rights:
            - delete
            - write
          type: Allow
        - user: Guest03
          rights:
            - FullControl
          type: Allow
      tags:
        - WIN_directory
~~~

### Running Playbook

~~~
> ansible-playbook win_directory.yml
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
