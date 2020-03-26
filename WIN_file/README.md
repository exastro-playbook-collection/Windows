# Ansible Role: Windows\WIN\_file
=======================================================

## Description
このロールは、WINDOWS SERVER 2016にファイルを作成するために使用されます。

## Supports
- 管理マシン(Ansibleサーバ)
 * Linux系OS（RHEL）
 * Ansible バージョン 2.4 以上 (動作確認バージョン 2.4, 2.9)
 * Python バージョン 2.x, 3.x  (動作確認バージョン 2.7, 3.6)
- 管理対象マシン(構築対象マシン)
 * Windows server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * Ansibleホストは管理対象マシンへPowershell接続できる必要がある。
- 管理対象マシン(インストール対象マシン)
  * Windows Server 2016
  * Powershell3.0+

## Role Variables
Role の変数値について説明します。

### Mandatory variables
~~~
　  * VAR_WIN_file_path             # 作成したいファイル（フルパスを含む）を指定する。
　  * VAR_WIN_file_state: 'absent'  # 指定したファイルに対して、作成操作（present）/削除操作（absent）を指定する。デフォルト値は　present  
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

指定のファイルを作成する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、  
以下のようなPlaybookを作成してください。  

- フォルダ構成
~~~
 - playbook
　  │── hosts/
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_file
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       file.yml
　  │                └─ README.md
　  └─ win_file.yml
~~~

- マスターPlaybook サンプル[win\_file.yml]
~~~
１）呼出す例：(ファイル作成)
　  - name: Windows File Create
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_file
　        VAR_WIN_file_path: 'C:\mytemp\test4.txt'
　        VAR_WIN_file_state: 'present'
　        tags:
　          - WIN_file
　
２）呼出す例：(ファイル削除)
　  - name: Windows File Delete
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_file
　        VAR_WIN_file_create_path: 'C:\mytemp\test4.txt'
　        VAR_WIN_file_state: 'absent'
　        tags:
　          - WIN_file
~~~

## Running Playbook

- 指定のファイルを作成/削除する時、以下のように実行します。

~~~sh
> ansible-playbook win_file.yml
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
