---
title: "World, Hello!"
slug: worldhello
description: "“不仅仅是 Hello world。”"
date: 2023-05-24T22:51:26+08:00
lastmod:
categories: "月魂"
tags: ["Hugo", "Blog", "Rust"]
---

正式拥有了属于自己的域名！

有了域名后，博客的曝光率也会大一些了罢（大嘘）

Anyway，在我的博客生涯中，这确实可以算是个有意义的节点

于是......

### World, hello

```Rust
fn greet_world() {
    let southern_germany = "Grüß Gott!";
    let chinese = "世界，你好";
    let english = "World, hello";
    let japanese = "世界よ、こんにちは";
    let regions = [southern_germany, chinese, english, japanese];
    for region in regions.iter() {
        println!("{}", &region);
    }
}

fn main() {
    greet_world();
}
```

灵感来自：[不仅仅是 Hello world](https://course.rs/first-try/hello-world.html)

<div style="text-align: center;">
  <img src="/images/world-hello.jpg" alt="Koishi" width="40%">
</div>
