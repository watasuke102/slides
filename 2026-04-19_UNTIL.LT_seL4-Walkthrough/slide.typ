#import "@watasuke102/slide:1.0.0": *
#show: slides

#template_title_main([seL4 Walkthrough])[
  2026-04-19 | UNTIL. LT \#0x0A

  わたすけ(\@watasuke1024)
]
#template_bio(change_text_size(-4pt)[
  - 筑波大学 mast 4年
  - #underline[*Twitter: watasuke1024*]\
    その他: watasuke102
  - Rustで自作OSをやっていた\ （やりたい）
])

#template_section("")
#template_section("seL4？")
#template_basic[
  == OSのカーネルって200色ある
  - Linuxカーネルなどは*モノリシックカーネル*と呼ばれる
    - I/Oやデバイスといった様々な機能を\ カーネル空間で実装
  - 対義語は#text(fill: green)[*マイクロカーネル*]
    - カーネルが*最小限の機能を持つ*
    - 「モノリシックカーネル」という語は\ これが登場してから生まれたらしい#text(fill: gray2)[（レトロニム）]
]
#template_basic[
  == マイクロカーネル、よさげ
  - モノリシックカーネルが持っていた機能は、\ ユーザーランドで*サーバー*として実装
    - OSが#underline[提供する機能を変えやすい]
  - カーネルが小さいから #underline[attack surfaceが小さい]！\
    #underline[デバッグが楽]！
]
#template_basic[
  == マイクロカーネル、渋い
  *遅くね？*
  - サーバー同士のやりとりは\ *IPC* (Inter-Process Communication) で行う
    - 情報処理推進特別委員会ではないですよ！
  - ボトルネックになりがち
    - IPC用のシステムコール、コンテキストスイッチ、etc...
]
#template_basic[
  == マイクロカーネル、渋くない！
  - IPC←ちゃんと作ると速くなる（575）
  - 高速なIPCを特徴とする#text(fill: green)[*L4*]の登場
  - Appleのセキュリティチップ「Secure Enclave」で\ L4が動いている
    - iPhoneやMacBookに搭載されている#text(fill: gray2)[（いた?）]
]
#template_basic[
  == seL4
  - *#text(fill: green)[se]cure #text(fill: green)[L4]*
  - *仕様がHaskellで書かれている*
    - そこからCのコードを自動生成
  - Isabelle/HOL による*形式検証が行われている*
]

#template_section("seL4の概念")
#template_basic[
  == Capability (ケーパビリティ)
  - 「何にアクセスできるか」を示すもの
  - 3種類ある：
    + *カーネルオブジェクト*へのアクセスを制御
    + *抽象リソース*へのアクセスを制御
    + *Untypedメモリ*へのアクセスを制御
]
#template_center(
  caption: link(
    "https://github.com/seL4/l4v/blob/master/spec/haskell/src/SEL4/Object/Structures.lhs#L46-L83",
  )[HaskellによるCapabilityの定義（一部）],
  change_text_size(-4pt)[
    ```hs
    data Capability
            = ThreadCap {
                capTCBPtr :: PPtr TCB }
            | NullCap
            | ReplyCap {
                capTCBPtr :: PPtr TCB,
                capReplyMaster :: Bool,
                capReplyCanGrant :: Bool }
            | IRQControlCap
            deriving (Eq, Show)
    ```
  ],
)
#template_center(
  upper: [
    == CNodeとCapability
    - Capabilityは#text(fill: green)[*CNode*]という配列に格納される
    - CNodeの各コンテナを*CSlot*と呼ぶ
    - 位置の指定には*CPtr*を用いる
      - メモリアドレスを指すポインタではない
  ],
  grid(
    columns: 5,
    [*CNode* #h(0.5cm)],
    box(stroke: 2pt + white, inset: 0.3em)[CSlot],
    box(stroke: 2pt + white, inset: 0.3em)[CSlot],
    box(stroke: 2pt + white, inset: 0.3em)[CSlot],
    box(stroke: (right: none, rest: 2pt + white), inset: 0.3em)[...],

    [], align(center, par(leading: 2pt)[↑ \ CPtr]),
  ),
)
#template_basic[
  == Capability
  - カーネルが起動してから最初に起動する\ #text(fill: green)[*ルートタスク*]が全てのCapabilityを持っている
  - ルートタスクが自身のCapabilityをコピーして\ 他のタスクに分け与える
]
#template_center(
  caption: [ルートタスクが持つCNodeのTCB Capabilityを\ 空きスロットにコピーする例],
  change_text_size(-4pt)[
    ```cpp
    seL4_CNode_Copy(
      // dest
      seL4_CapInitThreadCNode, boot_info->empty.start, seL4_WordBits,
      // src
      seL4_CapInitThreadCNode, seL4_CapInitThreadTCB,  seL4_WordBits,
      seL4_AllRights
    );
    ```
  ],
)
#template_basic[
  == Untyped memory
  - 連続した物理メモリの領域
  - これのリストが、それを操作するCapabilityとともに\ ルートタスクに渡される
  - Untyped Capabilityを、*カーネルオブジェクト*と\ それを操作するCapabilityに*Retype*できる
]
#template_center()[
  ```cpp
  seL4_Untyped_Retype(
    parent_untyped, // 変更元の Untyped Memory
    seL4_TCBObject, // 作成したいオブジェクトの種類
    seL4_TCBBits,   // オブジェクトのサイズ
    // 作成したCapabilityを格納するCSlot
    seL4_CapInitThreadCNode, // root
    0,                       // node_index
    0,                       // node_depth
    tcb_slot,                // node_offset
    1                        // 作成個数
  );
  ```
]
#template_center()[
  ```cpp
  seL4_CPtr tcb_slot = ...;
  seL4_Untyped_Retype(seL4_TCBObject, ...,
      tcb_slot, 1);
  // System Call!
  seL4_TCB_Configure(tcb_slot, ...);
  ```
]

//#template_section("ブート")

#template_section("スレッドを起動してみる")
#template_basic[
  == スレッドを作る方法
  - カーネルオブジェクトである\ *#text(fill: green)[TCB] (Thread Control Block)* を作成
    - これを作るにはもちろんCapabilityが必要
  - TCBが持つレジスタの値を書き換える
    - *rip* (Instruction Pointer) や *rsp* (Stack Pointer)
]
#template_basic[
  == やってみよう！
  - 本当はELFをロードしたかった
  - 時間が足りませんでした泣
  - メモリに機械語を直接書き込む脳筋スタイルで行く
]
#for i in range(2) {
  template_center(upper: [== やってみた], change_text_size(-6pt)[
    ```cpp
    seL4_CPtr create_object(seL4_BootInfo *boot_info, seL4_Word type) {
      seL4_CPtr cslot = boot_info->empty.start++;
      for (seL4_CPtr i = boot_info->untyped.start;
           i < boot_info->untyped.end; ++i) {
        if (boot_info->untypedList[i - boot_info->untyped.start].isDevice) {
          continue;
        }
        seL4_Error result = seL4_Untyped_Retype(i, type, 0,
          seL4_CapInitThreadCNode, 0, 0, cslot, 1);
        if (result == seL4_NoError) return cslot;
      }
    }
    ```
    #if i == 1 {
      place(left + top, move(
        dx: 1.5cm,
        dy: 7.49cm,
        box(stroke: 3pt + red, width: 19.5cm, height: 4.3em),
      ))
    }
  ])
}
#template_center(upper: [== メモリのマッピング], change_text_size(-7pt)[
  ```cpp
  const seL4_Word kMapAddr = 0xA000000000;
  seL4_CPtr frame = create_object(boot_info, seL4_X86_4K);
  seL4_CPtr pdpt  = create_object(boot_info, seL4_X86_PDPTObject);
  seL4_CPtr pd    = create_object(boot_info, seL4_X86_PageDirectoryObject);
  seL4_CPtr pt    = create_object(boot_info, seL4_X86_PageTableObject);
  seL4_X86_PDPT_Map(pdpt, seL4_CapInitThreadVSpace, kMapAddr,
                    seL4_X86_Default_VMAttributes);
  seL4_X86_PageDirectory_Map(pd, seL4_CapInitThreadVSpace, kMapAddr,
                             seL4_X86_Default_VMAttributes);
  seL4_X86_PageTable_Map(pt, seL4_CapInitThreadVSpace, kMapAddr,
                         seL4_X86_Default_VMAttributes);
  seL4_X86_Page_Map(frame, seL4_CapInitThreadVSpace, kMapAddr,
                    seL4_ReadWrite, seL4_X86_Default_VMAttributes);
  ```
])
#template_center(upper: [== コンパイラいつもありがとう])[
  ```sh
  $ bat a.c
  int main(int argc, char** argv) {
    *((volatile uint32_t*)0xA000000300) += 1;
    return 0;
  }
  $ clang -O0 -g -c a.c
  ```
]
#template_center(
  upper: [== binutils いつもありがとう],
  caption: [わかりやすくするために出力結果を切り貼りしています],
)[
  ```asm
  $ objdump -dfS a.o
    48 b8 00 03 00 00 a0 	movabs rax,0xa000000300
    00 00 00
    ff 00                	inc    DWORD PTR [rax]

  ```
]
#template_center(upper: [== 機械語かきまくり])[
  ```cpp
  uint8_t *p = (void *)kMapAddr;
  memset(p, 0, 1024 * 4);
  // movabs rax, 0xA0'0000'0300
  p[0] = 0x48; p[1] = 0xb8; p[3] = 0x03; p[6] = 0xa0;
  // inc [rax]
  p[10] = 0xff; p[11] = 0x00;
  // jmp -3
  p[12] = 0xeb; p[13] = 0xfc;
  ```
]
#template_center(
  upper: [== TCBの作成],
  change_text_size(-3pt)[
    ```c
    seL4_CPtr tcb = create_object(boot_info, seL4_TCBObject);
    seL4_TCB_Configure(tcb,
      seL4_CapNull,                // fault handler
      seL4_CapInitThreadCNode, 0,  // CNode
      seL4_CapInitThreadVSpace, 0, // VSpace
      0, 0);
    seL4_TCB_SetPriority(tcb, seL4_CapInitThreadTCB, 254);
    ```
  ],
)
#template_center(
  upper: [== TCBのレジスタ書き換え],
  change_text_size(-3pt)[
    ```c
    seL4_TCB_ReadRegisters(tcb, 0, 0,
      sizeof(regs) / sizeof(seL4_Word), &regs);

    regs.rip = kMapAddr;
    regs.rsp = &tcb_stack_base + sizeof(tcb_stack_base);

    seL4_TCB_WriteRegisters(tcb, 0, 0,
      sizeof(regs) / sizeof(seL4_Word), &regs);

    ```
  ],
)
#template_center(upper: [== 起動！])[
  ```c
  seL4_TCB_Resume(tcb);

  volatile uint32_t *write_dest = (void *)0xA000000300;
  while (1) {
    if ((*write_dest / 10) == 1234567) {
      printf("count reached (%u)\n", *write_dest);
      seL4_DebugDumpScheduler();
    }
  }
  ```
]

// ここから時間なくて発表できなかった
#template_center()[== デモ]
#template_basic()[
  == うまく動きませんでした
  - なんで？
  - スレッドが restart のまま動かない（575）
  - チュートリアルと違ってCapDLとかいう\ 謎のやつを使ってないから？
]
