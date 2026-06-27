#import "@watasuke102/slide:1.1.0": *
#show: slides.with(enable_page_number: false)
#set page(margin: 0.6cm)
#set list(spacing: 0.7em)
#show link: it => {
  show underline: it => it.body
  it
}

#set figure(gap: 0.3em)
#show figure.caption: set text(fill: gray1, size: 17pt)
#show figure.where(kind: image): set figure(supplement: none)

#template_title_main("52. XR Selection")[
  #text(fill: white)[*paper x7* #text(size: 19pt)[(Honorable Mention x1)]]

  筑波大学 IPLAB #change_text_size(-9pt)[(インタラクティブプログラミング研究室)]\

  情報メディア創成学類 B4 *渡辺耀介*
]

#let template_local(
  paper_name,
  doi,
  authors,
  orgs,
  honorable_mention: false,
  content,
  lower,
) = template_basic[
  #set text(size: 20pt)

  #show heading: set block(below: 0.17em) // between title and authors
  #set par(leading: 0.29em)
  #heading(
    link("https://doi.org/" + doi, text(size: 23pt, paper_name))
      + if honorable_mention {
        place(right, text(fill: green, size: 15pt)[
          #h(1em)
          #box(move(dy: 0.4cm, align(horizon, stack(
            dir: ltr,
            spacing: 0.3em,
            box(fill: green, image("img/honorable.png", height: 1.52em)),
            // naki
            move(dy: -1.98pt)[\[Honorable Mention\]],
          ))))
        ])
      },
  )

  #set par(
    leading: 0.45em, // between authors and orgs
    spacing: 0.75em, // between orgs and body
  )
  #text(fill: gray2, size: 0.8em, [#authors \ #text(size: 0.75em, orgs)])

  #content

  #align(center + bottom, lower)

  #place(bottom + right, text(size: 12pt, fill: gray2)[full paper])
]
#let org(num) = {
  show math.equation: set text(font: "Rounded M+ 1c", size: 14pt)
  // without braces, weird spaces surround the number
  [$#h(-0.2pt)^(#num)$]
}

#set list(marker: [-])

#template_local(
  [Redirected Pinch:\ #text(fill: green)[Efficient and Comfortable Bare-Hand Interaction] for 2D Windows in VR],
  "10.1145/3772318.3791512",
  [Wen Ying#org(1), Yeonsu Kim#org(2), Adil Rahman#org(1), Erzhen Hu#org(1), Geehyuk Lee#org(2), Seongkook Heo#org(1)],
  [(1) University of Virginia, (2) KAIST],
)[
  // - ハンドトラッキングによる操作手法は触覚および安定性に欠ける
  - 腰の近くに仮想的な入力面を表示して、そこへの入力を\ *遠方のスクリーンにマッピング*したのち、*ピンチにより確定*する手法を提案
  // - 一般に用いられているDirect Pinch、Gaze Pinch、Handray Pointerと比較する実験を行った
  - 提案手法は精度、効率、主体感、快適さの強いバランスを示した
][
  #stack(
    dir: ltr,
    spacing: 0.35em,
    figure(image("img/redirected-pinch_method.jpg", height: 7.96cm), caption: [提案手法]),
    figure(image("img/redirected-pinch_cmp.jpg", height: 5.4cm), caption: [比較対象となった手法]),
    figure(image("img/redirected-pinch_result.jpg", height: 7.96cm), caption: [実験の結果]),
  )
]

#template_local(
  [Uncertain Pointer: Situated Feedforward Visualizations \ for #text(fill: green)[Ambiguity-Aware AR Target Selection]],
  "10.1145/3772318.3790329",
  [Ching-Yi Tsai#org(1), Nicole Tacconi#org(1), Andrew D. Wilson#org(2), Parastoo Abtahi#org(1)],
  [(1) Princeton University, (2) Microsoft Research],
)[
  // - ターゲットの曖昧さ回避における視覚的な先行予測手法は未探索
  - ARにおける、可視化を用いた物体選択の*曖昧さ回避手法を比較*
  - 2つのオンライン実験をもとに、*位置および可視化手法によるトレードオフ*を特定
  // - 物体を遮蔽する可視化手法は好まれない傾向にあった
  // -
][
  #set image()
  #stack(
    dir: ltr,
    spacing: 0.4cm,
    figure(
      image("img/uncertain-pointer_disambiguation.jpg", height: 7.8cm),
      caption: [色付き境界線による曖昧さ回避],
    ),
    figure(
      image("img/uncertain-pointer_cmp.jpg", height: 8.97cm),
      caption: [曖昧さのタイプ、視覚効果、位置による分類],
    ),
  )
]

#template_local(
  [Point & Grasp: Flexible Selection of Out-of-Reach Objects\ Through #text(fill: green)[Probabilistic Cue Integration]],
  "10.1145/3772318.3790836",
  [Xuejing Luo#org(1), Hee-Seung Moon#org(2), Christian Holz#org(3), Antti Oulasvirta#org(1)],
  [(1) Aalto University, (2) Chung-Ang University, (3) ETH Zürich],
)[
  // - MR において手の届かない範囲にあるオブジェクトを選択するのは難しい
  // - 確率的な手がかりを統合するフレームワークを提案
  - *手の方向*および*掴むジェスチャの方向*を組み合わせて、\ オブジェクトが選択されている確率を計算する手法を提案
  - 基準となる手法と比べて、*精度*および*速度*が改善された
][
  #figure(image("img/point-grasp.jpg", height: 8.32cm))
]

#template_local(
  [VoiceRay: 3D Object #text(fill: green)[Selection Technique\ for Occluded and Dense Environments] in Virtual Reality],
  "10.1145/3772318.3790399",
  [Rumeysa Turkmen#org(1), Zahra Rasoulifar#org(1), Anil Ufuk Batmaz#org(1)],
  [(1) Concordia University],
)[
  // - VRにおいてレイキャストは広く使われているが、密集したオブジェクトもしくは他のオブジェクトに遮蔽されたオブジェクトを選択するのは難しい
  - "Third"のような*順序を発話*して*レイ方向のオブジェクトを指定*する手法を提案
  - 従来手法と比較して、*選択時間およびタスク時間が短縮*されるとともに、\ *エラー率も低下*したほか、*従来手法より高いSUSスコア*を獲得した
][
  #set image(height: 7.98cm)
  #stack(
    dir: ltr,
    spacing: 0.2cm,
    figure(image("img/voice-ray_method.jpg"), caption: [提案手法]),
    figure(image("img/voice-ray_cmp.jpg"), caption: [比較対象となった手法]),
  )
]

#template_local(
  [Hitchhiking Hands: Enabling "Virtually Direct" VR Manipulation\ by #text(fill: green)[Switching Multiple Hand Avatars with Gaze]],
  "10.1145/3772318.3790746",
  [Reigo Ban#org(1), Keigo Matsumoto#org(2), Takuji Narumi#org(1)],
  [(1) The University of Tokyo, (2) AIST],
)[
  // - 直接/間接にとらわれない新たな分類 *alignment / contact* を提案
  - 物理の手および仮想の手の*座標系が対応しているか* (alignment)、*仮想的な手が\ オブジェクトに触れるか* (contact) という点により3Dインタラクションを分類
  // - 仮想的直接に相当する *Hitchhiking Hands* を提案
  // - 物理的な手から離れた定義済みの位置に仮想的な手を配置して、\ *遠くのオブジェクトに「直接」触れて操作*できる手法を提案
  - 物理的な手から離れた定義済みの位置に*仮想的な手を複数配置*して、\ *視線により利用する手を切り替える*手法を提案
][
  #figure(image("img/hitchhiking-hands.jpg", height: 7.84cm))
]

#template_local(
  [Motion-Touch: Kinematic-based Adaptive Switch\ for #text(fill: green)[Enhancing Virtual-Hand Selection with Target Prediction] in AR/VR],
  "10.1145/3772318.3791956",
  [Yixuan Liu#org(1), Ruyang Yu#org(1), Haolong Li#org(1), Kunling Han#org(1), Chengxiao Dong#org(1), Tao Luo#org(1)],
  [(1) Southern University of Science and Technology],
)[
  // - AR/VRにおける仮想的な手を用いた選択手法には、速度と精度とのトレードオフという困難さがある
  - *運動に基づく#underline[トリガー切り替え]*および*ターゲットを予測する#underline[深層学習モデル]*による選択手法を提案
  - 基準手法と比べて*同等のエラー率*を保ちつつ*有意に短いトリガー時間*を発揮
][
  #show figure.caption: set text(size: 15pt)
  #stack(
    dir: ltr,
    spacing: 1.6cm,
    ..(
      [弾道フェーズ（トリガー無効）],
      [修正フェーズ（トリガー有効）],
      [再び移動が始まると最初に戻る],
    )
      .enumerate()
      .map(e => figure(
        image("img/motion-touch_" + str(e.at(0)) + ".jpg", height: 7.42cm),
        caption: e.at(1),
      )),
  )
  #v(0.8em) // avoid "full paper"
]

#template_local(
  [Investigating How #text(fill: green)[Physical Surfaces Can Serve as Common-Region Cues] for Perceptual Grouping of Virtual Elements in Augmented Reality],
  "10.1145/3772318.3790315",
  [Xuanhui Yang#org(1), Xuning Hu#org(1), Hai-Ning Liang#org(1), Xiaojuan Ma#org(1)],
  [(1) The Hong Kong University of Science and Technology],
  honorable_mention: true,
)[
  // #set list(spacing: 0.6em)
  - 物理世界にある平面の*方向* #text(fill: gray1, size: 18pt)[(水平/垂直)] および*距離*が\ AR内要素の*グルーピングに影響する*ことを示した
  - *相反する手がかりはグルーピングを困難にする*。\ このとき、参加者はグループ構造を明確にするために\ *様々な戦略を採用*した
][
  #set image()
  #stack(
    dir: ltr,
    spacing: 0.2cm,
    figure(image("img/yang_study1.jpg", height: 4.4cm), caption: [方向の影響を調査する実験の概要]),
    figure(image("img/yang_strategy.jpg", height: 5.87cm), caption: [参加者が用いた戦略]),
  )
  #place(
    right + top,
    dy: 3.06cm,
    figure(
      image("img/yang_competition.jpg", height: 4.8cm),
      caption: [相反する手がかり#text(size: 0.9em)[（近接性と平面）]],
    ),
  )
]
