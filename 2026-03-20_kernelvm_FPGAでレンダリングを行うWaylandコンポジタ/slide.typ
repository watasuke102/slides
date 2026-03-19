#import "@watasuke102/slide:1.0.0": *
#show: slides.with()

#template_title_main([FPGAでレンダリングを行う\ Waylandコンポジタ])[
  2026-03-20 | Kernel/VM探検隊＠つくば No3

  わたすけ(\@watasuke1024)
]
#template_bio(change_text_size(-4pt)[
  - *筑波大学* \
    情報メディア創成学類 新4年
  - #underline[*Twitter: watasuke1024*]\
    その他: watasuke102
  - Web / 低レイヤ（自作OS）
    - #change_text_size(-6pt)[#emoji.heart] Rust / TypeScript / C++
])
#template_section("")

#template_section("つくったもの")
#template_basic[
  == つくったもの
  - Linuxが動くFPGAボードの上で動く\ *Waylandコンポジタ*（ウィンドウマネージャ）
  - 特徴：#text(fill: green)[*FPGAが*] *自律的に描画*を行う
    - ループで `render()` を呼ぶなどして\ 明示的にレンダリングを行わなくて良い
]
#template_two_column(
  right_inset: false,
  left_size: 1fr,
  right_size: 9cm,
  [
    == Wayland？
    - GUIを実現する {ライブラリ,プロトコル}
    - X Window System の後継という文脈で\ 語られることが多い
    - #change_text_size(
        -3pt,
      )[#underline[*Waylandコンポジタ*]は、Wayland クライアントと*Waylandプロトコル*でやりとりをして、\ #text(fill: green)[*ウィンドウを管理*]する]
    #align(right + bottom)[
      #set par(spacing: 0.6em)
      Waylandのアーキテクチャ図

      #text(size: 12pt, link(
        "https://gitlab.freedesktop.org/wayland/wayland.freedesktop.org/-/blob/main/wayland-architecture.png",
        [gitlab.freedesktop.org/wayland/wayland.freedesktop.org/-/blob/main/wayland-architecture.png],
      ))]
  ],
  align(horizon + center, image("img/wayland_arch.jpg", width: 8.7cm)),
)
#template_basic[
  == Waylandコンポジタ、すごい
  いろいろやっている
  - ウィンドウの座標・サイズを管理する*だけではない*
  - 移動・リサイズ・最小化・最大化
  - キーボード・マウスといった入力装置の管理
  - ドラッグ&ドロップ
  - コピー&ペースト
]
#for i in range(2) {
  template_basic(change_text_size(6pt)[
    Q. なんでFPGA？

    #if i >= 1 [
      A. *COJTという授業の一環*で作ったから
    ]
  ])
}


#template_section("COJTとは")
#template_center(
  upper: [
    == COJT
    - *組み込み技術キャンパスOJT*
    - 筑波大学の情報学群で行われている授業
    - ハードウェアコースとソフトウェアコースがある
      - FPGAをやるのは前者
  ],
  image("img/cojt.png", height: 1fr),
)
#template_basic[
  == COJT ハードウェアコース
  - *FPGAで映像信号*を扱う
  - VGA信号を出力したり、\
    コマンドを受け取って描画を行ったり……
  - 高い機材やソフトウェアが使えて、うれしい
  - いい感じの教室が*24時間いつでも使い放題！*
]
#template_section("COJTでのあゆみ")
#template_basic[
  == 大まかな流れ
  + パターン表示回路
  + 表示回路
  // + キャプチャ回路←一瞬で終わったから言及しなくていいや
  + フィルタ回路
  + 描画回路
  + 自由課題
]
#template_center(
  upper: [
    == パターン表示回路
    - カラーバーみたいなやつを表示
    - 画像のような*パターンを生成するpatgenと*\ #text(fill: green, [*VGA信号を生成するsyncgen*]) の2つを主に実装
  ],
  image("img/cojt_pattern.jpg", height: 1fr),
)
#template_center(
  upper: [
    == VGA信号？
    - {垂直,水平}同期信号 (VSYNC, HSYNC) を出力
  ],
  caption: [実際に使っていたメモ],
  image("img/vga_spec.jpg", height: 1fr),
)
#template_basic[
  == 表示回路
  - メモリ上にある画像を読み込んで表示
  - AXIバスのマスター側としてメモリを読み出す
    - 読み出しなのでAR / Rチャネルを使う
  - のちに描画回路で再利用する
    - ちゃんと実装していないと終わる
]
#template_basic[
  == AXI？
  - *Advanced eXtensible Interface* の略
  - 通信インタフェースを定めたもの
  - マスターとスレーブの間でデータをやりとりできる
]
#template_center(
  upper: [
    == フィルタ回路
    - メモリから読み出した画像からR/G/Bの一部を抜き出し
    - フィルタリング処理を回路レベルで実装
    - フィルタ後の画像はAXIでメモリに書き込む
      - AW / W / Bチャネルが登場
  ],
  caption: [例）フィルタ処理でG要素のみ通した結果],
  grid(
    rows: 1fr,
    columns: 3,
    column-gutter: 0.4cm,
    image("img/icon.jpg", height: 1fr), [→], image("img/icon_green.jpg", height: 1fr),
  ),
)
#template_basic[
  == 描画回路
  - レジスタで描画コマンドを受け取る
  - 座標やサイズを計算して、矩形あるいは画像を描画
    - AXIでメモリに書き込み
    - 書き込み結果は表示回路が出力
  - 透明度（アルファブレンディング）も実装
  - *実装が多くて難しい*#text(fill: gray2)[（というか面倒）]
]
#template_center(
  upper: [== コマンド多すぎやねん（12個 !）],
  caption: change_text_size(
    -6pt,
  )[多すぎて訳がわからなくなったので、NotionにRust風の構文でまとめなおした],
  image("img/commands.jpg"),
)
#template_center(
  caption: change_text_size(
    -4pt,
  )[矩形描画+画像描画+アルファブレンドの全実装に成功した時のツイート],
  image("img/draw_tweet.jpg"),
)
#template_basic[
  #set page(margin: 0pt)
  #image("img/draw_circuit.jpg")
  // 再現ダルかったから成果発表会で使ったスライドをスクショしました！ｗ
  // GoogleスライドからJPEG/PNGでエクスポートしたらガビガビで終わった
]
#template_basic[
  == 自由課題
  *なんかやれ！*\
  はい……

  #text(fill: gray1)[（今まで作った回路を使って任意のものを作成する課題）]
]
#template_section("「自由課題」のあゆみ")
#template_basic[
  == COJTで使っていたFPGAボード
  *Ultra96-V2*
  - CPU (64bit Arm) とFPGAの双方が乗っている
  - #underline(text(fill: green, [*Linuxが動く*]))
  - FPGAはLinuxからPythonで制御
  #place(bottom + right, image("img/ultra96.png", height: 7cm))
]
#for i in range(2) {
  template_basic[
    == 自由課題
    - 描画回路は*位置を指定して画像を描画*できる
    - Waylandはクライアントから*ウィンドウの画像*を受け取る
    - FPGAのそばでは*Linuxが動いている*
    #if i >= 1 {
      grid(
        columns: 2,
        column-gutter: 8pt,
        [→], [Waylandコンポジタのレンダリング、\ *FPGAにやらせたらおもろい*やろな……笑],
      )
    }
  ]
}
#template_basic[
  == 目標
  - Wayland コンポジタを作る
  - そこでブラウザを開いてGoogleスライドを見せる
  - *プレゼン兼デモをぜんぶFPGAでやる！*
]
#template_basic[
  == Waylandコンポジタ と わたすけ
  - 実はWaylandコンポジタづくりは*3回目*
  - 1回目：*Zwin project*
    - #link("https://zwin.dev")
    - 2022年度 未踏アドバンスト事業
    - Meta Quest 2で動くVRデスクトップ環境
]
#template_basic[
  == Waylandコンポジタ と わたすけ
  - 2回目：*yaza*
    - 高専の卒業研究、未踏Advの延長線 #text(fill: gray2)[(?)]
    - Android (Termux) で動き、レンダリング機能をもたない
    - Unity製アプリとgRPCで通信して\
      *XREAL Air 2 (AR グラス) にデスクトップ環境を提供*
      - #change_text_size(-3pt)[XREAL SDKはUnityのみ！#text(fill: rgb("#FFF0"))[カスやね]]
]
#template_basic[
  == Waylandコンポジタ と わたすけ
  - XREALに表示している映像をWebSocketで転送する\ 機能を実装した
  - 卒研発表でこれを使ってデモをしようとしたら\
    本番でフリーズして死んだ
    - 発表練習で見たことがなかったバグを踏んだ
  - #text(fill: green)[*COJTの成果発表会でリベンジしたい！！*]
    - 作業時期も1年前の卒研と被っててすごい
]
#template_basic[
  == Waylandのしくみ
  - クライアントは*surface*を作る
    - #change_text_size(-2pt, text(
        fill: gray1,
      )[0個以上の出力装置に表示される可能性のある四角い領域])
  // A surface is a rectangular area that may be displayed on zero or more outputs
  - また、コンポジタとの共有メモリ *"buffer"* も作成する
  - #underline[*surface に buffer をアタッチ*]することで、\ ウィンドウの画像を指定できる
  - `commit()` を呼ぶことで、画像を更新したよ～と伝える
]
#template_basic[
  == 実装方針
  + *Waylandコンポジタ*：クライアントからbufferを受け取る
  + *FPGA*：bufferをAXIで読み取る
  + 読み取ったものを画像として描画
]
#template_center(
  upper: [
    == しくみ
  ],
  [
    #set par(leading: 0.3em)
    #align(center + horizon, grid(
      columns: (1fr, 4.0cm, 1fr),
      row-gutter: 0.3cm,
      grid.cell(colspan: 3, image("img/slide_mechanism.jpg")),
      // スライドからコピペしたせいでカスのhotfixをする羽目になってしまった
      // なんと画像にある左右の緑ボックスはサイズが違います（ゴミ）
      move(dx: 0.6cm)[
        #text(fill: green)[*Waylandコンポジタ*]\
        C++
      ],
      [],
      [
        #text(fill: green)[*描画回路*]\
        #change_text_size(-2pt)[Python & System Verilog]
      ],
    ))
  ],
)
#template_center(caption: [`commit()` の処理 (1)], change_text_size(-4pt)[
  ```cpp
  void Surface::commit() {
    if (this->buffer_.has_value()) {
      auto buffer = this->buffer_.value();
      struct wl_shm_buffer* shm_buffer = wl_shm_buffer_get(buffer);
      server::get().platform->commit_buffer(this->id, buffer);
    }
    // ...
  }
  ```
])
#template_center(caption: [`commit()` の処理 (2)], change_text_size(-4pt)[
  ```cpp
  void FpgaPlatform::commit_buffer(
    const core::Surface::Id& id, wl_resource* buffer) {
    constexpr uint8_t kCommitCommand = 0x10;

    auto buf_addr = (uint64_t)wl_shm_buffer_get_data(shm_buffer);
    send(this->socket_fd_, &kCommitCommand, 1, 0); // !

    wl_shm_buffer_begin_access(shm_buffer);
    send(this->socket_fd_, &buf_addr, 8, 0);
    wl_shm_buffer_end_access(shm_buffer);
  }
  ```
])
#template_center(caption: [受け取り手 (1)], change_text_size(-4pt)[
  ```py
  surfaces: dict[int, Surface] = {}

  def handle_event(self, conn, data):
    match data:
      # Surface.commit
      case b'\x10':
        surface_id = int.from_bytes(conn.recv(4), 'little')
        width      = int.from_bytes(conn.recv(4), 'little')
        # ...
        if self.surfaces.get(surface_id) == None:
          self.surfaces[surface_id] = Surface()
        self.surfaces[surface_id].commit(width, height, fmt, addr)
  ```
])
#template_center(caption: [受け取り手 (2)], change_text_size(-4pt)[
  ```py
  def commit(self, width, height, fmt, addr):
    if self.buffer.size == 0:
      self.width  = width
      self.height = height
      # !!
      self.buffer = allocate(
        shape = (width, height, self.pixel_size), dtype='u1')

    ctypes.memmove(self.buffer.ctypes.data, ctypes.c_void_p(addr),
      width * height * self.pixel_size)

    self.buffer.flush()
  ```
])
// #template_basic[
//   == メモリ管理
//   - コンポジタが持つbufferのメモリアドレスを\ UNIX abstractソケット経由で受け取り
//   - `allocate()` で確保したFPGAのメモリに `memmove` する
// ]
#template_center(
  upper: [== コンポジタ動作のようす],
  caption: [マウス入力],
  image("img/compositor_cursor.jpg"),
)
#template_center(
  upper: [== コンポジタ動作のようす],
  caption: [アルファブレンド],
  image("img/compositor_alpha-blend.jpg"),
)
#template_center(
  upper: [== コンポジタ動作のようす],
  caption: [ウィンドウが画面の*下以外*にはみ出ると、崩壊],
  image("img/compositor_collapse.jpg"),
)
// #template_basic[
//   == 自由課題
//   - せっかくウィンドウマネージャを作ったんだから\
//     発表もここでやりたいな……
//   - （いつも通り）Googleスライドで資料を作って\ Web ブラウザから開けば良さそう
// ]
// #template_center(
//   upper: [
//     == AArch64向けWebブラウザ、意外とない
//     - 以下は2026-03-12のニュース
//     - 発表会は01/30だったため、時すでに遅し
//   ],
//   image("img/discord_chromium.png", width: 100%),
// )
// #template_center(
//   upper: [
//     == Arch Linux ARMのChromiumは？
//     - なぜか起動しなかった
//     - 実行しても何も出力されなかった
//     - `ldd` してもライブラリは欠けていなかったが……
//   ],
//   image("img/archlinux-arm_chromium.png", height: 1fr),
// )
// #template_basic[
//   == Firefoxは？
//   - 起動後にクラッシュする
//   - プロトコルの実装が足りない？
//     - `gdk_seat_get_keyboard` でfailしていた
//     - キーボードまわりは未実装だったのでそれか？
//   // でも（形だけ）実装してうごかなかったんだよなあ
// ]
// #template_center(upper: [== Vivaldi！！！], image("img/vivaldi.jpg"))
// #template_center(upper: [== 起動した！], image("img/compositor_vivaldi.jpg"))
// #template_center(upper: [== どうにかなった], image("img/compositor_presentation.jpg"))
#template_center(
  upper: [
    == デモ
    - 発表会の直前にWebブラウザの起動に成功
    - #change_text_size(-5pt)[ほぼ ]*バグなしでデモ完走！*
      // 実は最後の最後でちょっと怪しい挙動をしていた
      - 超うれし～
  ],
  image("img/compositor_presentation.jpg"),
)
#template_basic[
  == おわり
  - 筑波大学でCOJTというおもしろ授業を受けた
  - FPGAにレンダリングさせるWaylandコンポジタを作った
  - その中でWebブラウザを開いて\ Googleスライドで発表した
  - COJTありがと～
  #place(bottom + left, grid(
    columns: 2,
    column-gutter: 16pt,
    image("img/watasuke102_cojt-compositor_qr.png", height: 5.0cm),
    move(dy: -5pt, change_text_size(-5pt)[←作成したコンポジタ]),
  ))
  #place(bottom + right, image("img/compositor_presentation.jpg", height: 7.7cm))
]

// backup
#pagebreak()
#template_basic[
  == なんでコンポジタのbufferを普通に読んでるの？
  - *Pythonがコンポジタを別スレッドとして起動する*ため、\ 直接メモリを読める
    - #align(horizon, change_text_size(
        -9pt,
        text(fill: gray2)[もっとうまいやり方はいくらでもあるだろうが、実装速度を優先した],
      ))
  #change_text_size(-5pt)[
    ```py
    def start_compositor(self):
      lib = ctypes.cdll.LoadLibrary('fpga-build/libcojt-compositor.so')
      thread = threading.Thread(target = lib.main)
      thread.start()
    ```]
]
#template_basic[
  == 未実装の機能
  - キーボード入力
    - 頑張ったけど発表会には間に合わなかった
  - ポップアップ#text(fill: gray2)[（右クリックメニュー）]
  - コピー&ペースト
  - ドラッグ&ドロップ
]
#template_basic[
  #set page(margin: 0pt)
  #image("img/slide_overview.jpg")
  // 成果発表会で使ったスライドをスクショしました2
]
