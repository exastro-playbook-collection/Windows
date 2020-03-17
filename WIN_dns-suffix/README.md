# Ansible Role: Windows\WIN\_dns-suffix
=======================================================

## Description
このロールは、windows server 2016のDNSサフィックスを設定するために使用されます。
  
* 注意事項  
  * DNS設定が行われていないサーバーで収集・パラメータ生成コードを用いて生成したパラメータファイルを本ロールで使用すると、エラーとなります。  
設定対象サーバーのDNS設定（プライマリDNSサフィックス）をクリアしたい場合は、以下のように引き数を追加してください。  
~~~  
VAR_WIN_dnsSuffix_primary:  
    NVDomain:  
~~~  

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

特にありません。

### Optional variables

~~~
* VAR_WIN_dnsSuffix_primary:       # プライマリDNSサフィックスを設定します。
      NVDomain: test.com               # 【このコンピュータのプライマリDNSサフィックス】を設定します。親項目が定義された場合、必須とします。
                                       # 大小文字区別します。値がnoneの場合、プライマリDNSサフィックスをクリアします。
      syncDomainWithMembership: yes    # 【ドメインメンバーシップが変更されるときにプライマリDNSサフィックスを変更する】を設定します。
                                       # 親項目が定義された場合、必須とします。
* VAR_WIN_dnsSuffix_specific:      # 【特定のDNSサフィックスに接続する】を設定します。
      useDomainNameDevolution: yes     # 【プライマリDNSサフィックスの親サフィックスを追加する（X）】を設定します。親項目が定義された場合、必須とします。
      searchList:                      # 【以下のDNSサフィックスを順に追加する（H）】を設定します。複数値を設定できます。大小文字区別します。
                                       # 設定されない場合、「プライマリおよび接続専用のDNSサフィックスを追加する」が有効になります。
        - test1.com
        - test2.com
        - test3.com
* VAR_WIN_dnsSuffix_nic:           # 【この接続のDNSサフィックス（S）】を設定します。複数の子項目を設定できます。
      - nicName: Ethernet0             # NIC名を指定します。親項目が定義された場合、必須とします。大小文字区別しません。
        suffixName: nic1.com           # DNSサフィックス名を指定します。親項目が定義された場合、必須とします。大小文字区別します。
* VAR_WIN_dnsSuffix_reboot: false  # 設定後、管理対象マシンをすぐ再起動するかどうか指定します。true/false（デフォルト値）
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
　  │          └── WIN_dns-suffix/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_dnsSuffix.yml
~~~

- マスターPlaybook サンプル[win\_dnsSuffix.yml]

~~~
#win_dnsSuffix.yml
---
- name: Windows dnsSuffix playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/WIN_dns-suffix
      VAR_WIN_dnsSuffix_primary:
          NVDomain: test.com
          syncDomainWithMembership: yes
      VAR_WIN_dnsSuffix_specific:
          useDomainNameDevolution: yes
          searchList:
            - testList1.com
            - testList2.com
            - testList3.com
      VAR_WIN_dnsSuffix_nic:
        - nicName: Ethernet0
          suffixName: nic1.com
        - nicName: Ethernet1
          suffixName: nic2.com
      VAR_WIN_dnsSuffix_reboot: false
      tags:
        - WIN_dns-suffix
  # reboot
  post_tasks:
    - include_role:
          name: WIN_reboot
      when: WIN_reboot_required == true
~~~

## Running Playbook

~~~sh
> ansible-playbook win_dnsSuffix.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_dnsSuffix\_evidence.yml]
~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_dns-suffix"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_dnsSuffix.yml]
~~~
---
- import_playbook: win_dnsSuffix_evidence.yml VAR_gathering_label=before

- name: Windows dnsSuffix playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/WIN_dns-suffix
      VAR_WIN_dnsSuffix_primary:
          NVDomain: test.com
          syncDomainWithMembership: yes
      VAR_WIN_dnsSuffix_specific:
          useDomainNameDevolution: yes
          searchList:
            - testList1.com
            - testList2.com
            - testList3.com
      VAR_WIN_dnsSuffix_nic:
        - nicName: Ethernet0
          suffixName: nic1.com
        - nicName: Ethernet1
          suffixName: nic2.com
      VAR_WIN_dnsSuffix_reboot: false

- import_playbook: win_dnsSuffix_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      #　「HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters」配下の全部情報
　    │   ├── 1                                      #　【このコンピュータのプライマリDNSサフィックス】設定のレジストリ情報
　    │   ├── 2                                      #　【ドメインメンバーシップが変更されるときにプライマリDNSサフィックスを変更する】設定のレジストリ情報
　    │   ├── 3                                      #　【プライマリDNSサフィックスの親サフィックスを追加する（X）】設定のレジストリ情報
　    │   ├── 4                                      #　【以下のDNSサフィックスを順に追加する（H）】設定のレジストリ情報
　    │   ├── 5                                      #　全てのNIC名の情報
　    │   ├── 6                                      #　NIC毎にDnsサフィックス情報
　    │   └── results.json                           #　各コマンドの情報を格納するJSONファイル
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── CurrentControlSet
　                    └── Services
　                        └── Tcpip
　                            └── Parameters
　                                    └── export.reg # DNSサフィックス設定のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
